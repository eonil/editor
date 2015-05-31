set -e

ADDR="https://github.com/Eonil/SQLite3"
REPO="SQLite3"
BRANCH="master"
COMMIT="dc19eb13858487da73dbd7a99922c77fb27e2fbe"



cd Project
cd Modules

# Delete.
chmod -R u+w ./$REPO
rm -rf ./$REPO

# Download.
git clone $ADDR
cd $REPO
git checkout $BRANCH
git reset --hard $COMMIT
rm -rf ./.git
chmod -f -R u-w ./*

