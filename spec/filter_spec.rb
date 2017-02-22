# encoding: utf-8
require 'logstash/devutils/rspec/spec_helper'
require 'logstash/plugin'
require 'logstash/filters/grok'

describe 'simple syslog line' do
  file = File.open('/test/conf/filter.conf', 'rb')
  config file.read
  file.close

  message = %(Mar 16 00:01:25 evita postfix/smtpd[1713]: connect from tcnksm.net[168.100.1.3])

  sample('@message' => message) do
    insist { subject['message'] }.should be 'connect from tcnksm.net[168.100.1.3]'
    insist { subject['program'] }.should be 'postfix/smtpd'
  end
end
