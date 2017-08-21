#! /bin/bash

sudo gem uninstall linmeric
gem build linmeric.gemspec
sudo gem install ./linmeric-0.2.1.gem
