#!/usr/bin/env ruby
require 'apigw'
require 'optparse'
params = ARGV.getopts('d:')
target_date = params["d"]

consumer_key = ENV['CONSUMER_KEY']
secret_key = ENV['SECRET_KEY']

session = ApiGW::Client.new config_path: 'config.yml', environment: 'production'
oauth = session.oauth consumer_key, secret_key
response = oauth.access_token
access_token = response.body["accessToken"]

puts ">>>>> response.status: #{response.status}"
puts ">>>>> response.body.accessToken:"
puts response.body["accessToken"]

#date = Time.now.strftime "%Y%m%d"
api_log = session.api_log access_token
api_log.get target_date

