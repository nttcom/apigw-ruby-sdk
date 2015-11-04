module ApiGW

  class OAuth < ApiBase

    class << self
      def api_name
        'oauth'
      end
    end

    def access_token
      data = {
        clientId: @consumer_key,
        clientSecret: @secret_key,
        grantType: 'client_credentials'
      }
      post_request 'accesstokens', data: data
    end

  end

end
