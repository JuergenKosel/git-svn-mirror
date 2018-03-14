# git-svn-mirror
Script collection to mirror all branches from subversion into (shared) git repository.

## Workflow
To mirror a svn repository into shared git (bare) repository do the following:

  - Init an empty git svn repository with `git svn init`, as described in `man git-svn`. For example if you want to mirror [felix](http://svn.apache.org/repos/asf/felix/), run the following command:
  ```
  git svn init --stdlayout http://svn.apache.org/repos/asf/felix/ felix
  ```

  - Before you fetch for the first time from the svn repository into the git svn repository, you need to add some configuration to the git svn repository.
  Therefore run the helper script [configGitSvnRepo.sh](configGitSvnRepo.sh)
  Continuing the example above:
  ```
  cd felix
  ../git-svn-mirror/configGitSvnRepo.sh
  ```

  - Configure the shared git repository as remote of the git svn repository.
  Continuing the example above:
  ```
  git clone --bare . ../felix.git
  git remote add sharedGitRepo ../felix.git
  ```

