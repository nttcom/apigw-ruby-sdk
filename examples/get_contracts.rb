#!/usr/bin/env ruby

require 'apigw'

access_token = ENV['ACCESS_TOKEN']
service_name = ENV['SERVICE_NAME']

session = ApiGW::Client.new config_path: 'config.yml', environment: 'production'
business_process = session.business_process access_token
response = business_process.get "contracts", service_name

puts ">>>>> HTTP status: #{response.status}"
puts ">>>>> items count: #{response.body['items'].count}" if response.success?
