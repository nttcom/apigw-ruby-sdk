# coding: utf-8
require 'spec_helper'

describe ApiGW::Client do
  describe '#request_access_token' do
    let!(:stub_connection) do
      # Faraday のスタブを作成
      Faraday.new do |conn|
        conn.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
          stub.post("/v1/oauth/accesstokens") do
            [ 200, {}, {
                "accessToken" => "dummy_access_token",
                "tokenType" => "BearerToken",
                "expiresIn" => "86399",
                "scope" => "READ WRITE",
                "issuedAt" => "1434961342009"
              }]
          end
        end
      end
    end

    let(:client) { ApiGW::Client.new }

    before do
      # ApiGW::Client#connection に :stub_connection を返させる
      allow(client).to receive(:connection).and_return(stub_connection)
    end

    it 'request success' do
      response = client.request_access_token("consumer_key", "secret_key")
      expect(response).to include("accessToken")
    end
  end
end
