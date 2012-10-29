#!/bin/bash

rbenv shell 1.9.3-p286
rbenv rehash
GEM_HOME=""
PATH=$DEFAULT_PATH:$GEM_HOME/bin
