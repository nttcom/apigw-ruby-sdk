#!/usr/bin/env ruby
require 'apigw'
require 'json'

consumer_key = ENV['CONSUMER_KEY']
secret_key = ENV['SECRET_KEY']

session = ApiGW::Client.new config_path: 'config.yml', environment: 'production'
oauth = session.oauth consumer_key, secret_key
response = oauth.access_token

puts ">>>>> response.status: #{response.status}"
puts ">>>>> response.body.accessToken:"
puts response.body["accessToken"]
access_token = response.body["accessToken"]

service_name = 'unol2'
data = open('new_service_order_data.json') { |io| JSON.load io }

business_process = session.business_process access_token
business_process.post "service-orders", service_name, data, querys: { pattern: 'new' }
