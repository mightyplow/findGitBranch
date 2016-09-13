pipe_target=$target_branch

function findGitBranch {
  $passedBranch = ${1:-latest}
  local branch_name='develop'

  if [ "$pipe_target" == "latest" ]; then
    echo "searching branch with last commit..."

      latest_branch=`git for-each-ref --sort=-committerdate --format="%(refname:short)" --count 1`
      echo "branch with last commit is $latest_branch"
      
      branch_name=${latest_branch/origin\//}
      echo "user $branch_name as branch name"
      
      #pipe_target=`grep -Eo '^[^/]+' <<< $branch_name`
      #echo "pipeline target is $pipe_target"
  else
    # find the correct branch for the passed target (from the remote branches)
    found_branch=`git branch -r | grep -m 1 $pipe_target`
    
    # strip remote namespace
    branch_name=${found_branch/origin\//}
    
    # if branch for target not found, take develop
    if [ -z $branch_name ]; then
      echo "Branch for target $pipe_target not found. Using develop instead"
      branch_name=develop
      #pipe_target=develop
    fi
  fi

  echo $branch_name
}