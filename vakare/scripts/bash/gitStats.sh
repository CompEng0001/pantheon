#! /usr/bin/env/ bash

# This will print a summary table of authors, total commits, insertions, and deletions based on the provided git log output.


# Author         Commits   Insertions  Deletions   Insertion-Deletion
# User1          6         97          11          86
# User2          8         104         11          93
# User3          2         66          5           61
# User4          4         46          1           45
# UserN          34        457         334         123

git log --shortstat --pretty=format:'%an' | awk '
  /^[a-zA-Z0-9_-]+$/ {
    author=tolower($1)
    author_width=length(author) > author_width ? length(author) : author_width
  }

  /file changed/ {
    gsub(/,/, "", $4)
    gsub(/,/, "", $6)
    gsub(/,/, "", $8)
    commits[author]++
    insertions[author]+=$4
    deletions[author]+=$6
  }

  END {
    printf "%-*s%-10s%-12s%-12s%-12s\n", author_width + 2, "Author", "Commits", "Insertions", "Deletions", "Insertion-Deletion"
    for (author in commits) {
      insertion_deletion_diff = insertions[author] - deletions[author]
      printf "%-*s%-10d%-12d%-12d%-12d\n", author_width + 2, author, commits[author], insertions[author], deletions[author], insertion_deletion_diff
    }
  }'
