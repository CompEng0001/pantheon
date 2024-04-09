#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages(ps: [ ])"

""" run git commands on multiple git clones https://github.com/mnagel/clustergit """

import argparse
import concurrent
import io
import itertools
import os
import re
import subprocess
import sys
import time
from argparse import ArgumentParser
from concurrent import futures
from typing import List, IO, Tuple

# Special imports for Windows systems
if os.name == 'nt':
    from ctypes import windll, c_ulong

# Optional autocomplete import
try:
    from argcomplete import autocomplete
except ImportError:
    # Notice: install "argcomplete" to automatic complete the arguments
    def autocomplete(_args):
        pass


def clearline(msg):
    # https://stackoverflow.com/a/53843296/2536029
    CURSOR_UP_ONE = '\033[K'
    ERASE_LINE = '\x1b[2K'
    sys.stdout.write(CURSOR_UP_ONE)
    sys.stdout.write(ERASE_LINE + '\r')
    print(msg, end='\r')


def colorize(color: str, message: str) -> str:
    return "%s%s%s" % (color, message, Colors.ENDC)


def decolorize(_color: str, message: str) -> str:
    for color in Colors.ALL:
        message = message.replace(color, '')
    return message


# noinspection PyClassHasNoInit
class Colors:
    BOLD = '\033[1m'  # unused
    UNDERLINE = '\033[4m'  # unused
    HEADER = '\033[95m'  # unused
    OKBLUE = '\033[94m'  # write operation succeeded
    OKGREEN = '\033[92m'  # readonly operation succeeded
    OKPURPLE = '\033[95m'  # readonly (fetch) operation succeeded
    WARNING = '\033[93m'  # operation succeeded with non-default result
    FAIL = '\033[91m'  # operation did not succeed
    ENDC = '\033[0m'  # reset color

    # list of all colors
    ALL = [BOLD, UNDERLINE, HEADER, OKBLUE, OKGREEN, OKPURPLE, WARNING, FAIL, ENDC]

    # map from ASCII to Windows color text attribute
    WIN_DICT = {
        BOLD: 15,
        UNDERLINE: 15,
        HEADER: 15,
        OKBLUE: 11,
        OKGREEN: 10,
        WARNING: 14,
        FAIL: 12,
        ENDC: 15
    }


def write_color(out: IO, color: str) -> None:
    # set text attribute for Windows and write ASCII color otherwise
    if os.name == 'nt' and out.isatty():
        windll.Kernel32.SetConsoleTextAttribute(
            windll.Kernel32.GetStdHandle(c_ulong(0xfffffff5)),
            Colors.WIN_DICT[color]
        )
    else:
        out.write(color)


def write_with_color(out: IO, msg: str) -> None:
    # build regex for splitting by colors, split and iterate over elements
    for p in re.split(('(%s)' % '|'.join(Colors.ALL)).replace('[', '\\['), msg):
        # check if element is a color
        if p in Colors.ALL:
            write_color(out, p)
        else:
            # plain text
            out.write(p)
            # flush required to properly apply color
            out.flush()


def read_arguments(args: List[str]) -> argparse.Namespace:
    parser = ArgumentParser(
        description="""
        clustergit will scan through all subdirectories looking for a .git directory.
        When it finds one it'll look to see if there are any changes and let you know.
        If there are no changes it can also push and pull to/from a remote location.
        """.strip(),
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser.add_argument(
        "-d", "--dir",
        dest="dirname",
        # Action=append allows the caller to specify `-d` multiple times.
        # For example: `-d foo -d bar/batz/git_repos` would process both directories.
        action="append",
        help="The directory to parse sub dirs from",
        default=[]
    )

    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        dest="verbose",
        default=False,
        help="Show the full detail of git status"
    )

    parser.add_argument(
        "-a", "--align",
        action="store",
        dest="align",
        default=70,
        type=int,
        help="Repo name align (space padding)"
    )

    parser.add_argument(
        "-r", "--remote",
        action="store",
        dest="remote",
        default="",
        help="Set the remote name (remotename:branchname)"
    )

    parser.add_argument(
        "--push",
        action="store_true",
        dest="push",
        default=False,
        help="Do a 'git push' if you've set a remote with -r it will push to there"
    )

    parser.add_argument(
        "-p", "--pull",
        action="store_true",
        dest="pull",
        default=False,
        help="Do a 'git pull' if you've set a remote with -r it will pull from there"
    )

    parser.add_argument(
        "-f", "--fetch",
        action="store_true",
        dest="fetch",
        default=False,
        help="Do a 'git fetch' if you've set a remote with -r it will fetch from there"
    )

    parser.add_argument(
        "--exec", "--execute",
        action="store",
        dest="command",
        type=str,
        default="",
        help="Execute a shell command in each repository"
    )

    parser.add_argument(
        "-c", "--clear",
        action="store_true",
        dest="clear",
        default=False,
        help="Clear screen on startup"
    )

    parser.add_argument(
        "-C", "--count-dirty",
        action="store_true",
        dest="count",
        default=False,
        help="Only display a count of not-clean repos"
    )

    parser.add_argument(
        "-q", "--quiet",
        action="store_true",
        dest="quiet",
        default=False,
        help="Skip startup info"
    )

    parser.add_argument(
        "-H", "--hide-clean",
        action="store_true",
        dest="hide_clean",
        default=False,
        help="Hide clean repos"
    )

    parser.add_argument(
        "-R", "--relative",
        action="store_true",
        dest="relative",
        default=False,
        help="Print relative paths"
    )

    parser.add_argument(
        "-n", "--no-colors",
        action="store_false",
        dest="colors",
        default=True,
        help="Disable ANSI color output. Disregard the alleged default -- color is on by default."
    )

    parser.add_argument(
        "-b", "--branch",
        action="store",
        dest="branch",
        default="(master|main)",
        help="Warn if not on a branch matching this Regex. Set to empty string (-b '') to disable this feature."
    )

    parser.add_argument(
        "--recursive",
        action="store_true",
        dest="recursive",
        default=False,
        help="Recursively search for git repos"
    )

    parser.add_argument(
        "--skip-symlinks",
        action="store_true",
        dest="skipSymLinks",
        default=False,
        help="Skip symbolic links when searching for git repos"
    )

    parser.add_argument(
        "-e", "--exclude",
        action="append",
        dest="exclude",
        default=[],
        help="Regex to exclude directories"
    )

    parser.add_argument(
        "-B", "--checkout-branch",
        action="store",
        dest="cbranch",
        default=None,
        help="Checkout branch"
    )

    parser.add_argument(
        "--warn-unversioned",
        action="store_true",
        dest="unversioned",
        default=False,
        help="Prints a warning if a directory is not under git version control"
    )

    parser.add_argument(
        "--workers",
        type=int,
        dest="thread_pool_workers",
        default=4,
        help="Workers in thread pool for parallel execution"
    )

    parser.add_argument(
        "--print-asap",
        action="store_true",
        dest="print_asap",
        default=False,
        help="Print repository status as soon as possible not preserving order"
    )

    parser.add_argument(
        "--global-ignore-file",
        type=str,
        dest="global_ignore_file",
        default="$HOME/.config/clustergit/.clustergit-ignore",
        help="Global clustergit-ignore file"
    )

    autocomplete(parser)
    options = parser.parse_args(args)
    return options


def die_with_error(error: str = "Undefined Error!") -> None:
    """Writes an error to stderr"""
    write_with_color(sys.stderr, "Error: %s\n" % error)
    sys.exit(1)


class GitDir:
    def __init__(self, path: str, options: argparse.Namespace) -> None:
        self.path = path

        if options.relative:
            self.path = os.path.relpath(self.path, options.dirname)

        self.dirty = None
        self.msg_buffer = io.StringIO()

    def analyze(self, options: argparse.Namespace) -> None:
        cmdprefix = ''
        if os.name != 'nt':
            cmdprefix = cmdprefix + ' LC_ALL=C'

        if options.verbose:
            self.write_to_msg_buffer("\n")
            self.write_to_msg_buffer("---------------- " + self.path + " -----------------\n")

        status, out = self.run('%s git branch' % cmdprefix, options, self.path)
        branches = out.strip().split('\n')

        for branch in branches:
            branch = branch.strip('* ')
            status, out = self.run('%s git checkout %s' % (cmdprefix, branch), options, self.path)
            if options.verbose:
                self.write_to_msg_buffer(out + "\n")

            messages = []
            clean = True
            can_push = False
            can_pull = True

            if len(options.branch) > 0 and not re.search(fr'On branch {options.branch}\n', out):
                messages.append(colorize(Colors.WARNING, f"On branch {branch}, not matching {options.branch}"))
                can_pull = False
                clean = False

            if re.search(r'nothing to commit.?.?working (directory|tree) clean.?', out):
                messages.append(colorize(Colors.OKBLUE, "No Changes"))
                can_push = True
            elif 'nothing added to commit but untracked files present' in out:
                messages.append(colorize(Colors.WARNING, "Untracked files"))
                can_push = True
                clean = False
            else:
                messages.append(colorize(Colors.FAIL, "Changes"))
                can_pull = False
                clean = False

            if 'Your branch is ahead of' in out:
                messages.append(colorize(Colors.FAIL, "Unpushed commits"))
                can_pull = False
                clean = False

            if clean:
                if not options.hide_clean:
                    messages = [colorize(Colors.OKGREEN, "Clean")]
                else:
                    messages = []

            self.dirty = not clean

            if can_push and options.push:
                status, push = self.run(
                    '%s git push %s'
                    % (cmdprefix, ' '.join(options.remote.split(":"))), options, self.path
                )
                if options.verbose:
                    self.write_to_msg_buffer(push + "\n")
                if re.search(r'\[(remote )?rejected\]', push):
                    messages.append(colorize(Colors.FAIL, "Push rejected"))
                else:
                    messages.append(colorize(Colors.OKBLUE, "Pushed OK"))

            if can_pull and options.pull:
                status, pull = self.run(
                    '%s git pull %s'
                    % (cmdprefix, ' '.join(options.remote.split(":"))), options, self.path
                )
                if options.verbose:
                    self.write_to_msg_buffer(pull + "\n")
                if re.search(r'Already up.to.date', pull):
                    if not options.hide_clean:
                        messages.append(colorize(Colors.OKGREEN, "Pulled nothing"))
                elif "CONFLICT" in pull:
                    messages.append(colorize(Colors.FAIL, "Pull conflict"))
                elif "fatal: No remote repository specified." in pull \
                        or "There is no tracking information for the current branch." in pull:
                    messages.append(colorize(Colors.WARNING, "Pull remote not configured"))
                elif "fatal: " in pull:
                    messages.append(colorize(Colors.FAIL, "Pull fatal"))
                    messages.append("\n" + pull)
                else:
                    messages.append(colorize(Colors.OKBLUE, "Pulled"))

            if options.fetch:
                status, fetch = self.run(
                    '%s git fetch --all --prune %s'
                    % (cmdprefix, ' '.join(options.remote.split(":"))), options, self.path
                )
                if options.verbose:
                    self.write_to_msg_buffer(fetch + "\n")
                if "error: " in fetch:
                    messages.append(colorize(Colors.FAIL, "Fetch fatal"))
                else:
                    messages.append(colorize(Colors.OKPURPLE, "Fetched"))
                if status != 0:
                    messages.append(colorize(Colors.FAIL, "Fetch unsuccessful"))

            if options.command:
                exit_status, output = self.run(
                    '%s %s' % (cmdprefix, options.command),
                    options, self.path
                )
                if not options.colors:
                    output = decolorize('', output)
                if not options.quiet:
                    messages.append('\n' + output)
                    if exit_status != 0:
                        msg = "The command exited with status {s} in {r}\nThe output was:{o}"
                        msg = msg.format(s=exit_status, r=self.path, o=output)
                        self.write_to_msg_buffer(colorize(Colors.FAIL, msg))

            if options.cbranch:
                status, checkoutbranch = self.run(
                    '%s git checkout %s'
                    % (cmdprefix, options.cbranch), options, self.path
                )
                if "Already on" in checkoutbranch:
                    if not options.hide_clean:
                        messages.append(colorize(Colors.OKGREEN, "No action"))
                elif "error: " in checkoutbranch:
                    messages.append(colorize(Colors.FAIL, "Checkout failed"))
                else:
                    messages.append(colorize(Colors.OKBLUE, "Checkout successful"))

            if not options.count and messages:
                self.write_to_msg_buffer(self.path.ljust(options.align) + f" ({branch}): ")
                write_with_color(self.msg_buffer, ", ".join(messages) + "\n")

        if options.verbose:
            self.write_to_msg_buffer("---------------- " + self.path + " -----------------\n")

    def run(self, command: str, options: argparse.Namespace, work_dir: str) -> Tuple[int, str]:
        if options.verbose:
            print('Running command in %s: %s' % (work_dir, command))

        proc = subprocess.Popen(
            command,
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            cwd=work_dir
        )
        out, err = proc.communicate()

        if isinstance(out, bytes):
            out = out.decode(sys.stdout.encoding)
        if isinstance(err, bytes):
            err = err.decode(sys.stderr.encoding)

        if options.verbose and err:
            print('Error output for command in %s: %s' % (work_dir, err))

        return proc.returncode, out

    def write_to_msg_buffer(self, msg: str) -> None:
        """Writes a message to the msg_buffer"""
        self.msg_buffer.write(msg)

    def get_message(self) -> str:
        """Retrieves the message from the buffer"""
        return self.msg_buffer.getvalue()

def fetch_dirty_repos(options: argparse.Namespace) -> None:
    if options.clear:
        os.system("clear")

    if not options.quiet:
        print('Scanning for git repos...')

    repos = []
    start = time.time()

    # If no directories are specified, default to the current directory
    if not options.dirname:
        options.dirname = ["."]

    for dirname in options.dirname:
        for root, _dirs, files in os.walk(dirname):
            if options.skipSymLinks and os.path.islink(root):
                continue
            if '.git' in _dirs:
                ignore_patterns = []
                rel_root = os.path.relpath(root, dirname)
                ignore = False
                for pattern in ignore_patterns:
                    if re.match(pattern, rel_root):
                        ignore = True
                        break
                if ignore:
                    continue
                repos.append(root)

    with concurrent.futures.ThreadPoolExecutor(max_workers=options.thread_pool_workers) as executor:
        gitdirs = [GitDir(repo, options) for repo in repos]
        for _ in executor.map(lambda x: x.analyze(options), gitdirs):
            pass
        
        # Output the results
        repo_name_length = max(len(os.path.basename(gitdir.path)) for gitdir in gitdirs)
        print("Repo".ljust(repo_name_length) + " | Branch | Status")
        print("=" * repo_name_length + " | " + "=" * 20 + " | " + "=" * 20)

        for gitdir in gitdirs:
            branches_status = gitdir.get_message().strip().split("\n")
            repo_name = os.path.basename(gitdir.path)  # Get the base name of the directory
            for idx, branch_status in enumerate(branches_status):
                branch, status = branch_status.split(":", 1)
                branch_name = branch.split("(", 1)[0].strip()  # Extract only the branch name
                if idx == 0:
                    print(repo_name.ljust(repo_name_length) + " | " + branch_name.ljust(20) + " | " + status.strip())
                else:
                    print("".ljust(repo_name_length) + " | " + branch_name.ljust(20) + " | " + status.strip())
                # Set repo_name empty after printing it once for a repo
                repo_name = ""


    if not options.quiet:
        print('Found and fetched %s repos in %.2f seconds.' % (len(repos), time.time() - start))

def main(args: List[str] = None) -> None:
    """Main entry point"""
    if args is None:
        args = sys.argv[1:]
    options = read_arguments(args)
    fetch_dirty_repos(options)


if __name__ == "__main__":
    main()