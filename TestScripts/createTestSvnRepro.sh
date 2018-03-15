#!/bin/bash
# Create a demo/test svn repository from
# See also https://git-scm.com/book/en/v2/Git-and-Other-Systems-Git-as-a-Client
# and http://svnbook.red-bean.com/en/1.7/svn.reposadmin.create.html

if [ -d test-svn ]
then
    echo "test-svn already exist -> Exiting"
    exit 1
fi

mkdir test-svn
svnadmin create test-svn
echo "#!/bin/sh" > test-svn/hooks/pre-revprop-change
echo "exit 0;" >> test-svn/hooks/pre-revprop-change
chmod +x test-svn/hooks/pre-revprop-change

# Create standard layout
svn mkdir -m"Create standard layout directories" file://`pwd`/test-svn/trunk file://`pwd`/test-svn/branches file://`pwd`/test-svn/tags
