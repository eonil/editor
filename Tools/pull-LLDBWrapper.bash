set -e

ADDR="https://github.com/Eonil/LLDBWrapper"
REPO="LLDBWrapper"
BRANCH="master"
COMMIT="9e8770dd675c1b17f1dbce87612e2e93f7d695f9"



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

