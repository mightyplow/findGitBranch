#!/usr/bin/env bash

function test {
    source findGitBranch.sh;

    if [ $(type -t "find_git_branch") != "function" ]; then
        echo "function find_git_branch should exist"
        return 1
    fi
}

test