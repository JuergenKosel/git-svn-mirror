#!/bin/bash
# Set git svn related configuration settings.
# This settings have impact into who git believes is the author of
# a commit and so influences the commit id.

###################################
# Run this script inside the git svn repository!

git config --add svn.addAuthorFrom true
git config --add svn.useLogAuthor true
git config --add svn.pushmergeinfo true
