#!/bin/bash -x
# Script to fill the test repository
# For the simplicity use the content and history of this git repository.

REPRO_ROOT=$(cd "$(dirname "$0")/.." && pwd)

GIT_SVN_TEST_REPRO=${REPRO_ROOT}_test_git_svn
GIT_TEST_REPRO=${REPRO_ROOT}_test_git
SVN_REPRO_URL="file://${REPRO_ROOT}/test-svn-repository"

if [ -d ${GIT_SVN_TEST_REPRO} ]
then
    echo "${GIT_SVN_TEST_REPRO} already exists -> skipping creation"
else
    # Before you fetch for the first time from the svn repository into the git svn repository,
    git svn init --stdlayout ${SVN_REPRO_URL} ${GIT_SVN_TEST_REPRO}

    # Add some configuration to the git svn repository.
    cd ${GIT_SVN_TEST_REPRO}
    ${REPRO_ROOT}/configGitSvnRepo.sh
fi

git clone --bare ${GIT_SVN_TEST_REPRO} ${GIT_TEST_REPRO}

cd ${GIT_SVN_TEST_REPRO}
# Configure the shared git repository as remote of the git svn repository.
git remote add sharedGitRepo ${GIT_TEST_REPRO}

# Run the mirror script to initially fill the git svn repository
${REPRO_ROOT}/git-svn-mirror.sh

# Add this repository as a remote
git remote add GitSvnMirror ${REPRO_ROOT}
# Get the content
git fetch GitSvnMirror
git checkout -b MirrorMaster GitSvnMirror/master
# Rebase onto trunk
git rebase trunk MirrorMaster
# dcommit the new trunk into the svn reprository
git svn dcommit

# Create a tag in the svn repository:
svn cp -m"Create test branch" ${SVN_REPRO_URL}/trunk ${SVN_REPRO_URL}/tags/test-tag-$(date +%F-%H-%M-%S)

# Now update the test svn repository
${REPRO_ROOT}/git-svn-mirror.sh

# The git svn repository and the git mirror repository should now contain the added svn tag (as a branch)

#remove the branch  MirrorMaster, because it is not longer needed
git checkout trunk
git branch -D MirrorMaster

echo "Created git svn reposiory in ${GIT_SVN_TEST_REPRO}"
echo "and created git mirror repository in ${GIT_TEST_REPRO}"
