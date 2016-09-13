#!/bin/bash

function findGitBranch {
  local passedBranch=${1:-latest}
  local branch_name='develop'

  if [[ "$passedBranch" == "latest" ]]; then
    echo "searching branch with last commit..."

    local latest_branch=`git for-each-ref --sort=-committerdate --format="%(refname:short)" --count 1`
    echo "branch with last commit is $latest_branch"
    
    # remove the origin part from the branch name since it's a remote branch
    branch_name="${latest_branch/origin\//}"
    echo "use $branch_name as branch name"
  else
    # find the exact branch (from the remote branches)
    echo "looking for exact branch $passedBranch"
    local found_branch=`git branch -r | grep -Em 1 "\b$passedBranch$"`
    
    if [[ -n "$found_branch" ]]; then
      # remove the origin part in the branch name
      branch_name=${found_branch/origin\//}
    else
      local namespaceBranch="${passedBranch/\/*/}"
      echo "exact branch $passedBranch not found. looking for namespace branch $namespaceBranch"

      found_branch=`git branch -r | grep -Em 1 "\b$namespaceBranch"`

      if [[ -n "$found_branch" ]]; then
        # remove the origin part in the branch name
        branch_name=${found_branch/origin\//}

        echo "found branch with namespace $namespaceBranch: $found_branch"
      else
        echo "no branch with namespace $namespaceBranch found"
      fi
    fi  
  fi

  echo "found branch is $branch_name"
  echo "$branch_name"
}