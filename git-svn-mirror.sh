#!/bin/bash

git svn fetch
git svn rebase
git fetch --tags sharedGitRepo

SVNBRANCHES=$(git branch -r --list 'origin/*')

for SVNBRANCH in $SVNBRANCHES
do
    GITBRANCH=$(echo $SVNBRANCH | sed -e '{ s/origin\/// }')
    git branch -f $GITBRANCH $SVNBRANCH
    git push --tags sharedGitRepo $GITBRANCH
done
