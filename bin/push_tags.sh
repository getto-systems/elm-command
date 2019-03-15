#!/bin/bash

git remote add super https://gett-systems:$GITLAB_ACCESS_TOKEN@gitlab.com/getto-systems-labo/elm/command.git
git remote add buckup https://getto-systems:$GITHUB_ACCESS_TOKEN@github.com/getto-systems/elm-command.git
git tag $(cat .release-version)
git push super HEAD:master --tags
git push buckup HEAD:master --tags
