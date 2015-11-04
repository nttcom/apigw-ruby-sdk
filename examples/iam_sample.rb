#!/usr/bin/env ruby
$LOAD_PATH.push('.')
require 'apigw'
require 'json'
require "iam_data"

consumer_key = ENV['CONSUMER_KEY']
secret_key = ENV['SECRET_KEY']
session = ApiGW::Client.new config_path: 'config.yml', environment: 'production'
oauth = session.oauth consumer_key, secret_key
response = oauth.access_token

puts ">>>>> response.status: #{response.status}"
puts ">>>>> response.body.accessToken:"
puts response.body["accessToken"]
access_token = response.body["accessToken"]

iam = session.iam access_token
users_data = []
1.times do |i|
  mail_prefix = ramdom_nam
  mail_address = mail_prefix.concat("@dummy.com")
  password = 'Iac46494649'
  users_data << ramdom_data(mail_address)
end

p '[1. bulk user crete...]'
p users_data
p JSON.generate(users_data)
response = iam.post "users", users_data
user_uuid =  response.body["users"][0]["uuid"] rescue nil
user_consumer_key =  response.body["users"][0]["consumerKey"] rescue nil
user_consumer_secret =  response.body["users"][0]["consumerSecret"] rescue nil
search_user_uuid = "users/" << user_uuid
iam.get search_user_uuid

p '[2. group create...]'
p ramdom_group_name_data
response = iam.post "groups", ramdom_group_name_data
group_uuid = response.body["groups"][0]["uuid"] rescue nil
search_group_uuid = "groups/" << group_uuid
iam.get search_group_uuid

p '[3. role create...]'
role_data =  get_role_data
p role_data
response = iam.post "roles", role_data
role_uuid = response.body["roles"][0]["uuid"] rescue nil
search_role_uuid = "roles/" << role_uuid
iam.get search_role_uuid

p '[4. attach group to role...]'
attach_group_to_role_path = "groups/" << group_uuid  << "/roles/" << role_uuid
p attach_group_to_role_path
response = iam.put attach_group_to_role_path
iam.get search_group_uuid

p '[5. attach group to user...]'
attach_group_to_user_path = "groups/" << group_uuid  << "/users/" << user_uuid
p attach_group_to_user_path
response = iam.put attach_group_to_user_path
search_group_users = "groups/" << group_uuid << "/users"
iam.get search_group_users

p '[6. test iam user request APIs]'
client = ApiGW::Client.new config_path: 'config.yml', environment: 'production'
iam_oauth = client.oauth user_consumer_key, user_consumer_secret
response = iam_oauth.access_token
iam_access_token = response.body["accessToken"]

p '[get business-process API...]'
service_name = 'bocn'
business_process = client.business_process iam_access_token
business_process.get "contracts", service_name

p '[get APILog API...]'
date = Time.now.strftime "%Y%m%d"
api_log = client.api_log iam_access_token
api_log.get date

p '[get IAM API...]'
iam_user_iam = client.iam iam_access_token
iam_user_iam.get "users"

p '[7. delete role from group...]'
delete_role_from_group_path = "groups/" << group_uuid  << "/roles/" << role_uuid
p delete_role_from_group_path
response = iam.delete delete_role_from_group_path
iam.get search_group_uuid

p '[get business-process API...]'
service_name = 'uno'
business_process.get "contracts", service_name
