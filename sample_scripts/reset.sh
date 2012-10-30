#!/bin/bash

rbenv shell --unset
rbenv rehash
GEM_HOME=$DEFAULT_GEM_HOME
PATH=$DEFAULT_PATH:$GEM_HOME/bin
