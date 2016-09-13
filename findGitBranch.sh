#!/bin/bash

function findGitBranch {
  passedBranch=${1:-latest}
  local branch_name='develop'

  if [ "$passedBranch" == "latest" ]; then
    echo "searching branch with last commit..."

    local latest_branch=`git for-each-ref --sort=-committerdate --format="%(refname:short)" --count 1`
    echo "branch with last commit is $latest_branch"
    
    # remove the origin part from the branch name since it's a remote branch
    branch_name="${latest_branch/origin\//}"
    echo "use $branch_name as branch name"
  else
    # find the correct branch for the passed target (from the remote branches)
    local found_branch=`git branch -r | grep -Em 1 "\b$passedBranch\b"`
    
    if [ -n $found_branch ]; then
      branch_name=${found_branch/origin\//}
    fi
  fi

  echo "$branch_name"
}