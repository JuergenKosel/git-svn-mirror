#!/bin/bash -x

git svn fetch
git svn rebase
git fetch --tags sharedGitRepo

SVNBRANCHES=$(git branch -r --list 'origin/*')

for SVNBRANCH in $SVNBRANCHES
do
    GITBRANCH=${SVNBRANCH#origin/} # As recommended, see http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02
    git branch -f $GITBRANCH $SVNBRANCH
    git push --tags sharedGitRepo $GITBRANCH
done
