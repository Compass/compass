#!/bin/sh

cd core && bundle install --quiet && bundle exec rake test && cd .. &&
  cd cli && bundle install --quiet && bundle exec rake && cd ..
