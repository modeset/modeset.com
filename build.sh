#!/bin/bash
source ~/.rvm/scripts/rvm
gem install bundler
bundle install
rake ci:setup:rspec specrake ci:setup:rspec spec
