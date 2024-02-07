#! /usr/bin/env/ bash

# This will print a summary table of authors, total commits, insertions, and deletions based on the provided git log output.
# By default checks current branch or you can specify the branch you want.

# Addition of grep -B 1 -E --no-group-separator is to retrieve the first line before file/s changed as some times there are two authors, pusher and merger. The no -group-separator removes -- between each returned line by grep

# Can see per branch all whole repo branch

# Author         Commits   Insertions  Deletions   Insertion-Deletion
# User1          6         97          11          86
# User2          8         104         11          93
# User3          2         66          5           61
# User4          4         46          1           45
# UserN          34        457         334         123.


git log $1 --shortstat --pretty=format:'%an' | grep -B 1 -E --no-group-separator 'changed' | awk '

/^[a-zA-Z0-9_-]+$/ {
    author=tolower($1)
    author_width=length(author) > author_width ? length(author) : author_width
  }

  /changed/ {
    gsub(/,/, "", $4)
    gsub(/,/, "", $6)
    gsub(/,/, "", $8)
    c[author]++
    i[author]+=$4
    d[author]+=$6
   }

  END {
    printf "%-*s%-10s%-12s%-12s%-12s\n", author_width + 2, "Author", "Commits", "Insertions", "Deletions", "Insertion-Deletion"
    for (author in c) {
      i_d_diff = i[author] - d[author]
      printf "%-*s%-10d%-12d%-12d%-12d\n", author_width + 2, author, c[author], i[author], d[author], i_d_diff
    }
  }'
