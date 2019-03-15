#!/bin/bash

bump_main(){
  elm bump && grep '"version"' elm.json | cut -d'"' -f4 > .release-version
}

bump_main
