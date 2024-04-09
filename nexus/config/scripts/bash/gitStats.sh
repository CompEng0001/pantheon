#!/usr/bin/env bash

# This will print a summary table of authors, total commits, insertions, and deletions based on the provided git log output.
# By default checks current branch or you can specify the branch you want.

# Can see per branch all whole repo branch

# Author                 Commits   Insertions  Deletions   Insertion-Deletion
# User1                  6         97          11          86
# User2                  8         104         11          93
# User3                  2         66          5           61
# User4                  4         46          1           45
# UserN                  34        457         334         123
# Total                  60        864        362          502
# Avg                    7.5       108        45.25        62.75

git log $1 --shortstat --pretty=format:'%cn' | awk '

  /^[[:alpha:]][[:alnum:]_ -]+$/ {
    author=$0
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
    total_commits = 0
    total_insertions = 0
    total_deletions = 0
    total_i_d_diff = 0

    printf "%-*s%-10s%-12s%-12s%-12s\n", author_width + 2, "Author", "Commits", "Insertions", "Deletions", "Insertion-Deletion"
    for (author in c) {
      i_d_diff = i[author] - d[author]
      total_commits += c[author]
      total_insertions += i[author]
      total_deletions += d[author]
      total_i_d_diff += i_d_diff
      printf "%-*s%-10d%-12d%-12d%-12d\n", author_width + 2, author, c[author], i[author], d[author], i_d_diff
    }

    printf "%-*s%-10d%-12d%-12d%-12d\n", author_width + 2, "Total", total_commits, total_insertions, total_deletions, total_i_d_diff
    printf "%-*s%-10.2f%-12.2f%-12.2f%-12.2f\n", author_width + 2, "Avg", total_commits / length(c), total_insertions / length(c), total_deletions / length(c), total_i_d_diff / length(c)
  }'
