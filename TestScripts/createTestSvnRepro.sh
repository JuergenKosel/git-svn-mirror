#!/bin/bash
# Create a demo/test svn repository from
# See also https://git-scm.com/book/en/v2/Git-and-Other-Systems-Git-as-a-Client
# and http://svnbook.red-bean.com/en/1.7/svn.reposadmin.create.html

REPRO_ROOT=$(cd "$(dirname "$0")/.." && pwd)

if [ -d ${REPRO_ROOT}/test-svn-repository ]
then
    echo "test-svn-repository already exist -> Exiting"
    exit 1
fi

mkdir ${REPRO_ROOT}/test-svn-repository
svnadmin create ${REPRO_ROOT}/test-svn-repository
echo "#!/bin/sh" > ${REPRO_ROOT}/test-svn-repository/hooks/pre-revprop-change
echo "exit 0;" >> ${REPRO_ROOT}/test-svn-repository/hooks/pre-revprop-change
chmod +x ${REPRO_ROOT}/test-svn-repository/hooks/pre-revprop-change

# Create standard layout
svn mkdir -m"Create standard layout directories" file://${REPRO_ROOT}/test-svn-repository/trunk file://${REPRO_ROOT}/test-svn-repository/branches file://${REPRO_ROOT}/test-svn-repository/tags
