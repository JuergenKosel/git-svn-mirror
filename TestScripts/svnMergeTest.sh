#!/bin/bash -x
# Script to test how handles git-svn a merge, which is done by svn

REPRO_ROOT=$(cd "$(dirname "$0")/.." && pwd)
SVN_REPRO_URL="file://${REPRO_ROOT}/test-svn-repository"
# Create the svn repository if not already existing
${REPRO_ROOT}/createSvnReporo.sh ${REPRO_ROOT}/test-svn-repository

# Create a branch within the svn repository
svn cp -m"Create test vendor branch" ${SVN_REPRO_URL}/trunk ${SVN_REPRO_URL}/branches/mergeTest

# Checkout the just created branch by svn and generate some commits
svn checkout ${SVN_REPRO_URL}/branches/mergeTest test-svn || exit 1

cd test-svn
echo "dummy message 1" >> mergeTest_file.txt
svn add mergeTest_file.txt
svn commit -m"commit of dummy message 1" mergeTest_file.txt

# Now create a new commit in the trunk
svn switch ^/trunk
echo "dummy message 2" >> mergeTrunk_file.txt
svn add mergeTrunk_file.txt
svn commit -m"Commit of dummy message 2 into trunk" mergeTrunk_file.txt

# Create now another commit in the branch
svn switch ^/branches/mergeTest
echo "dummy message 3" >> mergeTest_file.txt
svn commit -m"commit of dummy message 3"
svn up

# Now merge the trunk into the current branch
svn merge ^/trunk
svn commit -m"Merge of trunk into mergeTest"
