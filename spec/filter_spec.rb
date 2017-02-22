# encoding: utf-8
require 'logstash/devutils/rspec/spec_helper'

# #### START
# https://github.com/colinsurprenant/logstash-input-syslog/blob/906337b030e9563c8c23f6b4f44c0ad2f08a4fbc/spec/inputs/syslog_spec.rb#L18
# running the grok code outside a logstash package means
# LOGSTASH_HOME will not be defined, so let's set it here
# before requiring the grok filter
unless LogStash::Environment.const_defined?(:LOGSTASH_HOME)
  LogStash::Environment::LOGSTASH_HOME = File.expand_path('../../', __FILE__)
end

# temporary fix to have the spec pass for an urgen mass-publish requirement.
# cut & pasted from the same tmp fix in the grok spec
# see https://github.com/logstash-plugins/logstash-filter-grok/issues/72
# this needs to be refactored and properly fixed
module LogStash::Environment
  # also :pattern_path method must exist so we define it too
  unless method_defined?(:pattern_path)
    def pattern_path(path)
      ::File.join(LOGSTASH_HOME, 'patterns', path)
    end
  end
end
# #### END

require 'logstash/plugin'
require 'logstash/inputs/syslog'
require 'logstash/filters/grok'

describe 'simple syslog line' do
  file = File.open('/test/conf/filter.conf', 'rb')
  config file.read
  file.close

  message = %(Mar 16 00:01:25 evita postfix/smtpd[1713]: connect from tcnksm.net[168.100.1.3])

  sample('@message' => message) do
    insist { subject.get('message') } == ('connect from tcnksm.net[168.100.1.3]')
  end

  sample('@message' => message) do
    insist { subject.get('program') } == ('postfix/smtpd')
  end
end
