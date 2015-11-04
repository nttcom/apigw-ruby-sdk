#!/usr/bin/env ruby

require 'apigw'

access_token = ENV['ACCESS_TOKEN']
date = Time.now.strftime "%Y%m%d"

session = ApiGW::Client.new config_path: 'config.yml', environment: 'production'
api_log = session.api_log access_token
response = api_log.get date

puts ">>>>> HTTP status: #{response.status}"
puts ">>>>> Records count: #{response.body['Records'].count}" if response.success?
