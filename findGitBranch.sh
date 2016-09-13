#!/bin/bash

function findGitBranch {
  local passedBranch=${1:-latest}

  # branch_name gets exposed to the containing shell
  branch_name='develop'

  if [[ "$passedBranch" == "latest" ]]; then
    echo "searching branch with last commit..."

    local latestBranch=`git for-each-ref --sort=-committerdate --format="%(refname:short)" --count 1`
    echo "branch with last commit is $latestBranch"
    
    # remove the origin part from the branch name since it's a remote branch
    branch_name="${latestBranch/origin\//}"
    echo "use $branch_name as branch name"
  else
    # Note: this only looks in remote branches

    # find the exact branch (from the remote branches)
    echo "looking for exact branch $passedBranch"
    local foundBranch=`git branch -r | grep -Em 1 "\b$passedBranch$"`
    
    if [[ -n "$foundBranch" ]]; then
      # remove the origin part in the branch name
      branch_name=${foundBranch/origin\//}
    else
      local namespaceBranch="${passedBranch/\/*/}"
      echo "exact branch $passedBranch not found. looking for namespace branch $namespaceBranch"

      foundBranch=`git branch -r | grep -Em 1 "\b$namespaceBranch"`

      if [[ -n "$foundBranch" ]]; then
        # remove the origin part in the branch name
        branch_name=${foundBranch/origin\//}

        echo "found branch with namespace $namespaceBranch: $foundBranch"
      else
        echo "no branch with namespace $namespaceBranch found"
      fi
    fi  
  fi

  # remove whitespaces
  branch_name=${branch_name//[[:blank:]]/}

  echo "found branch is $branch_name"
}