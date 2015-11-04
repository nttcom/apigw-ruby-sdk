#!/usr/bin/env ruby

require 'apigw'

consumer_key = ENV['CONSUMER_KEY']
secret_key = ENV['SECRET_KEY']

session = ApiGW::Client.new config_path: 'config.yml', environment: 'production'
oauth = session.oauth consumer_key, secret_key
response = oauth.access_token

puts ">>>>> HTTP status: #{response.status}"
puts ">>>>> accessToken: #{response.body['accessToken']}" if response.success?
