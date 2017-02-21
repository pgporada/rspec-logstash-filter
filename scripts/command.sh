#!/bin/bash
# This script is supposed to be run on Docker container.
# This means you can not run this script directly from your local env.
#
# This script execute 2 type of tests.
# The one is syntax test by logstash command, the other is rspec test to check parsing result.
set -e

export PATH="/opt/logstash/vendor/jruby/bin/:$PATH"

echo "----> Test filter syntax"
time /opt/logstash/bin/logstash -t -f /test/conf/filter.conf

echo "----> Run rspec of filtering"
/opt/logstash/vendor/bundle/jruby/1.9/bin/rspec /test/spec/filter_spec.rb
