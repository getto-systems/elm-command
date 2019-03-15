#!/bin/bash

bump_main(){
  local json
  local version
  json=elm.json
  version=.release-version

  elm bump && git add $json && grep '"version"' $json | cut -d'"' -f4 > $version
}

bump_main
