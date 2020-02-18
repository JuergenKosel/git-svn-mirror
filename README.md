# git-svn-mirror
Script collection to mirror all branches from subversion into (shared) git repository.

  SVN-REPOSITORY => git svn repository => shared git repository

## Workflow
To mirror a svn repository into shared git (bare) repository do the following:

  - Init an empty git svn repository with `git svn init`, as described in `man git-svn`. For example if you want to mirror http://your-svn-server.example.org/svn/exampleProject, run the following command:
  ```bash
  git svn init --stdlayout http://your-svn-server.example.org/svn/exampleProject exampleProject
  ```
  - In case you want to avoid to introduce binaries from svn into git, as suggested for example in 
    [migrate-other-systems-to-git](https://docs.microsoft.com/en-us/azure/devops/learn/git/migrate-other-systems-to-git#remove-binary-dependencies-and-assets), then you should use a `git svn init` command similar to this one:
  ```bash
  git svn init --stdlayout --ignore-paths='.(dll|exe|lib|pdb|so[\.\d]*|a)$' http://your-svn-server.example.org/svn/exampleProject exampleProject
  ```
  - The regular expression in the example above matches the following file name endings:
     - `*.dll`
     - `*.exe`
     - `*.lib`
     - `*.pdb`
     - `*.so.1.2.3`
     - `*.a`
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

# Problems

## Different git commit-ids

After merge commits it happens some times, that the git-commit-ids of
two git-svn repositories become different. Even if the git-commit-ids
of the two repositories were synchron before the merge-commit.

In my expierience, with the following workaround the
git-repositories become synchronous again, if applied soon enough:

1. Select the git-svn repository, which became out of sync with the
   shared repository. And change the working directory into this
   repository.
   For excample: `cd secondary-repo`
2. Force the git-svn branch onto the corresponding commit of the
   reference repository. For example, if the branch trunk is out of
   sync:
   `cp .git/refs/remotes/sharedGitRepo/trunk .git/refs/remotes/origin`
3. If the current checked out branch is the one, which has got out of
   sync, reset it to the head of the reference branch, e.g.:
   `git reset sharedGitRepo/trunk`
4. Let git-svn update the references:
   `git svn fetch`

# Tests

Please take a look into the test script [TestScripts/fillTestRepro.sh](TestScripts/fillTestRepro.sh).
Running this test script will create the following:

  - A test svn repository: ./test-svn-repository
  - A git svn repository: ../git-svn-mirror_test_git_svn
  - A shared git repository: ../git-svn-mirror_test_git

The test script could give some idea, how to write an own script, to forward changes from a git repository back into the svn repository.
