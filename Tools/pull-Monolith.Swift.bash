set -e

ADDR="https://github.com/Eonil/Monolith.Swift"
REPO="Monolith.Swift"
BRANCH="master"
COMMIT="4661d464fe45bdb84bba0d75ce46864a4279b5f5"



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

