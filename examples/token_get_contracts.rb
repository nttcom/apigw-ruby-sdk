#!/usr/bin/env ruby
require 'apigw'
require 'optparse'
params = ARGV.getopts('n:')

consumer_key = ENV['CONSUMER_KEY']
secret_key = ENV['SECRET_KEY']

session = ApiGW::Client.new config_path: 'config.yml', environment: 'production'
oauth = session.oauth consumer_key, secret_key
response = oauth.access_token

puts ">>>>> response.status: #{response.status}"
puts ">>>>> response.body.accessToken:"
puts response.body["accessToken"]

p SecureRandom.uuid

service_name = params["n"]
access_token = response.body["accessToken"]
business_process = session.business_process access_token
business_process.get "contracts", service_name
