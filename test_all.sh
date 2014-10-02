#!/bin/sh

cd core && bundle install --quiet && bundle exec rake test && cd .. &&
cd cli && bundle install --quiet && bundle exec rake && cd .. &&
cd cli && (BUNDLE_GEMFILE=gemfiles/sass_3_3.gemfile bundle install --quiet && bundle exec rake test) && cd ..
cd import-once && bundle install --quiet && bundle exec rake test && cd .. &&
cd import-once && (BUNDLE_GEMFILE=Gemfile_sass_3_2 bundle install --quiet && bundle exec rake test) && cd ..
cd cli && bundle install --quiet && bundle exec rake && cd .. &&
cd sprites && bundle install --quiet && bundle exec rake && cd ..
