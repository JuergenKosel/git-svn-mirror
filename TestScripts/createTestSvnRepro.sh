#!/bin/bash
# Create a demo/test svn repository from
# See also https://git-scm.com/book/en/v2/Git-and-Other-Systems-Git-as-a-Client
# and http://svnbook.red-bean.com/en/1.7/svn.reposadmin.create.html

# The directory to create the svn repository must be given as 1st argument
SVNREPRODIR=$1

if [ -d ${SVNREPRODIR} ]
then
    echo "test-svn-repository already exist -> Exiting"
    exit 1
fi

mkdir -p ${SVNREPRODIR}
svnadmin create ${SVNREPRODIR}
echo "#!/bin/sh" > ${SVNREPRODIR}/hooks/pre-revprop-change
echo "exit 0;" >> ${SVNREPRODIR}/hooks/pre-revprop-change
chmod +x ${SVNREPRODIR}/hooks/pre-revprop-change

# Create standard layout
svn mkdir -m"Create standard layout directories" file://${SVNREPRODIR}/trunk file://${SVNREPRODIR}/branches file://${SVNREPRODIR}/tags
