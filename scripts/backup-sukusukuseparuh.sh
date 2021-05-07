#!/usr/bin/env bash

set -e

# Ensure we're in the current script's folder
cd "$(dirname "$0")"

# Clone repo
git clone "https://$GH_ACCESS_TOKEN@github.com/lhl2617/SukuSukuSeparuh"
# cd into repo
cd SukuSukuSeparuh
# Find the latest backup branch name
# list all branches
last_backup_branch=$(git branch -a |
    # trim whitespace
    xargs -L1 echo |
    # filter out non-backup branches
    grep -E "^remotes/origin/[0-9]{8}-[0-9]{6}" |
    # sort
    sort |
    # take last entry
    tail -n1)
branch_diff=$(git diff master.."$last_backup_branch")
branch_diff_size=${#branch_diff}
if [[ $branch_diff_size -ne 0 ]]; then
    echo "Default branch differs from last backup $last_backup_branch"
    echo "Backing up..."
    backup_branch_name=$(date '+%Y%m%d-%H%M%S')
    git branch "$backup_branch_name"
    git checkout "$backup_branch_name"
    git push --set-upstream origin "$backup_branch_name"
    echo "Back up to $backup_branch_name successful"
else
    echo "No change since last backup--not backing up"
fi
