# git-svn-mirror
Script collection to mirror all branches from subversion into (shared) git repository.

  SVN-REPOSITORY => git svn repository => shared git repository

## Workflow
To mirror a svn repository into shared git (bare) repository do the following:

  - Init an empty git svn repository with `git svn init`, as described in `man git-svn`. For example if you want to mirror http://your-svn-server.example.org/svn/exampleProject, run the following command:
  ```
  git svn init --stdlayout http://your-svn-server.example.org/svn/exampleProject exampleProject
  ```

  - Before you fetch for the first time from the svn repository into the git svn repository, you need to add some configuration to the git svn repository.
  Therefore run the helper script [configGitSvnRepo.sh](configGitSvnRepo.sh)
  Continuing the example above:
  ```
  cd exampleProject
  ../git-svn-mirror/configGitSvnRepo.sh
  ```

  - Configure the shared git repository as remote of the git svn repository.
  ```
  git remote add sharedGitRepo git@gitserver.example.org:path/to/yourShared/Repository
  ```

  - Run periodically [git-svn-mirror.sh](git-svn-mirror.sh), e.g. as a cron job.

# Tests

Please take a look into the test script [TestScripts/fillTestRepro.sh](TestScripts/fillTestRepro.sh).
Running this test script will create the following:

  - A test svn repository: ./test-svn-repository
  - A git svn repository: ../git-svn-mirror_test_git_svn
  - A shared git repository: ../git-svn-mirror_test_git

The test script could give some idea, how to write an own script, to forward changes from a git repository back into the svn repository.
