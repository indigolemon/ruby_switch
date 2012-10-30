#!/bin/bash

# Change these lines to suit your project
rbenv shell 1.9.3-p286
GEM_HOME=/path/to/gem_home

# Don't edit below here
rbenv rehash
PATH=$DEFAULT_PATH:$GEM_HOME/bin
