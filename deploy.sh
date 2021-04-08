#!/bin/sh

git remote add gigalixir https://$GIGALIXIR_EMAIL:$GIGALIXIR_API_KEY@git.gigalixir.com/$GIGALIXIR_APP_NAME.git

BRANCH=$(if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then echo $TRAVIS_BRANCH; else echo $TRAVIS_PULL_REQUEST_BRANCH; fi)
echo "TRAVIS_BRANCH=$TRAVIS_BRANCH, PR=$PR"
echo "------------------------------------"
echo "BRANCH=$BRANCH"

if [ "$BRANCH" == "main" ]; then
  echo "Pushing HEAD to main branch on Gigalixir."
  git push gigalixir HEAD:main --verbose
  echo "Deploy completed."
fi

echo "Exiting."