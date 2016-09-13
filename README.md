# findGitBranch

A bash script, which tries to find a passed git branch name.

## Purpose

On build systems like Jenkins, you sometimes need to ensure a build pipeline of branches.
Let's for example assume we have two git projects A and B with each having a develop and a release branch.

A is a dependency of B and when a specific branch of A is built, you require the same branch to be built in B.
Let's say, the release branch of A gets an update and therefore the release branch of B needs to get built.

This script provides a function called find_git_branch which accepts an optional parameter for the branch name to be found.
If this parameter is not set, then internally 'latest' gets used which let's the script look for the git branch with the last commit.

Since the script tries to find the branch in the remote branches, a remote name is required. This can be passed as the second parameter.
If it's not given, 'origin' gets used. 

## How it works

- if 'latest' or no branch name is passed to the function, then the script looks for the git branch with the last commit
- if a branch name is given, then the script
    - tries to find a branch with the exact name in the remote branches and if not found
    - strips everything after a first '/' (i.e. in release/1.2.0) and looks for a remote branch which starts with the part before the /
- If nothing is found the branch name develop is used

## Return value

Since it's not possible to really return a string from a bash function, a variable called FOUND_BRANCH gets exposed to the
surrounding shell.

## Example

Let's say, the script in build job of project B starts with $target='release/1.2.0' which got passed from a triggering build job of project A.
The git branches of project B are master, develop and release/2.1.0.

We include the bash file to get the function available

```
source findGitBranch.sh
```

Then we call the function find_git_branch with the parameter $target
```
find_git_branch $target
```

Since the branch with the name release/1.2.0 is not found, the function tries to find a branch starting with release.
The branch release/2.1.0 is found and gets exposed in the FOUND_BRANCH variable.