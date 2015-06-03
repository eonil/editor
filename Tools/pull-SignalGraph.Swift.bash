
set -e

ADDR="https://github.com/Eonil/SignalGraph.Swift"
REPO="SignalGraph.Swift"
BRANCH="master"
COMMIT="HEAD"





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




