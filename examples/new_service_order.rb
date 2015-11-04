#!/usr/bin/env ruby

require 'apigw'
require 'json'

access_token = ENV['ACCESS_TOKEN']
service_name = 'unol2'
data = open('new_service_order_data.json') { |io| JSON.load io }

client = ApiGW::Client.new config_path: 'config.yml', environment: 'production'
business_process = client.business_process access_token
response = business_process.post "service-orders", service_name, data, querys: { pattern: 'new' }

puts ">>>>> HTTP status #{response.status}"
if response.success?
  response_key = response.body['key']
  puts ">>>>> circuitEntryId: #{response_key['circuitEntryId']}, circuitEntrySubid: #{response_key['circuitEntrySubid']}"
end
