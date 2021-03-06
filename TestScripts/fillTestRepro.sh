#!/bin/bash -x
# Script to fill the test repository
# For the simplicity use the content and history of this git repository.

REPRO_ROOT=$(cd "$(dirname "$0")/.." && pwd)

${REPRO_ROOT}/createSvnReporo.sh ${REPRO_ROOT}/test-svn-repository

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

if [ ! -d ${GIT_TEST_REPRO} ]
then
    git clone --bare ${GIT_SVN_TEST_REPRO} ${GIT_TEST_REPRO}

    cd ${GIT_SVN_TEST_REPRO}
    # Configure the shared git repository as remote of the git svn repository.
    git remote add sharedGitRepo ${GIT_TEST_REPRO}
fi

# Create a vendor branch in the svn repository
svn cp -m"Create test vendor branch" ${SVN_REPRO_URL}/trunk ${SVN_REPRO_URL}/branches/vendor_branch

cd ${GIT_SVN_TEST_REPRO}
# Run the mirror script to initially fill the git svn repository
${REPRO_ROOT}/git-svn-mirror.sh

# Add this repository as a remote
git remote add GitSvnMirror ${REPRO_ROOT}
# Get the content
git fetch GitSvnMirror
git checkout -b MirrorMaster GitSvnMirror/master
# Rebase onto trunk
git rebase vendor_branch MirrorMaster
# dcommit the new vendor_branch into the svn reprository
git svn dcommit

# Merge the vendor_branch into the trunk
git checkout trunk
git merge --no-ff -m"Merge vendor_branch into trunk" MirrorMaster
git svn dcommit

#remove the branch  MirrorMaster, because it is not longer needed
git branch -D MirrorMaster

# Create a tag in the svn repository:
svn cp -m"Create test tag" ${SVN_REPRO_URL}/trunk ${SVN_REPRO_URL}/tags/test-tag-$(date +%F-%H-%M-%S)

# Now update the test svn repository
${REPRO_ROOT}/git-svn-mirror.sh

# The git svn repository and the git mirror repository should now contain the added svn tag (as a branch)


echo "Created git svn reposiory in ${GIT_SVN_TEST_REPRO}"
echo "and created git mirror repository in ${GIT_TEST_REPRO}"
