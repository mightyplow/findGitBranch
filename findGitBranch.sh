#!/bin/bash

function find_git_branch {
  local passedBranch=${1:-latest}
  local remoteName=${2:-$remoteName}

  # branch_name gets exposed to the containing shell
  FOUND_BRANCH='develop'

  if [[ "$passedBranch" == "latest" ]]; then
    echo "searching branch with last commit..."

    local latestBranch=`git for-each-ref --sort=-committerdate --format="%(refname:short)" --count 1`
    echo "branch with last commit is $latestBranch"
    
    # remove the $remoteName part from the branch name since it's a remote branch
    FOUND_BRANCH="${latestBranch/$remoteName\//}"
    echo "use $FOUND_BRANCH as branch name"
  else
    # Note: this only looks in remote branches

    # find the exact branch (from the remote branches)
    echo "looking for exact branch $passedBranch"
    local foundBranch=`git branch -r | grep -Em 1 "\b$passedBranch$"`
    
    if [[ -n "$foundBranch" ]]; then
      # remove the $remoteName part in the branch name
      FOUND_BRANCH=${foundBranch/$remoteName\//}
    else
      local namespaceBranch="${passedBranch/\/*/}"
      echo "exact branch $passedBranch not found. looking for namespace branch $namespaceBranch"

      foundBranch=`git branch -r | grep -Em 1 "\b$namespaceBranch"`

      if [[ -n "$foundBranch" ]]; then
        # remove the $remoteName part in the branch name
        FOUND_BRANCH=${foundBranch/$remoteName\//}

        echo "found branch with namespace $namespaceBranch: $foundBranch"
      else
        echo "no branch with namespace $namespaceBranch found"
      fi
    fi  
  fi

  # remove whitespaces
  FOUND_BRANCH=${FOUND_BRANCH//[[:blank:]]/}

  echo "found branch is $FOUND_BRANCH"
}