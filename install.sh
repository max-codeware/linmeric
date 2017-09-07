#! /bin/bash

if  which linmeric > /dev/null; then
  echo Uninstalling old version of linmeric...
  gem uninstall linmeric -x
fi

echo Building gem...
gem build linmeric.gemspec
echo
echo Installing linmeric...
gem install ./linmeric-0.2.1.gem
