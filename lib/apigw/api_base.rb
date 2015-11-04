# coding: utf-8
module ApiGW

  class ApiBase

    class << self
      def api_name
        raise NotImplementedError
      end

      def require_authorization?
        false
      end
    end

    def initialize(client, opts = {})
      @client       = client
      @consumer_key = opts[:consumer_key]
      @secret_key   = opts[:secret_key]
      @access_token = opts[:access_token]
    end

    # メソッドをまとめて定義
    [:get, :post, :put, :delete, :options].each do |verb|
      define_method "#{verb}_request" do |path, opts = {}|
        request verb, path, opts
      end
    end

    private

    def request(method, path, opts = {})
      clz = self.class

      url = path.nil? ? clz.api_name : "#{clz.api_name}/#{path}"

      opts_copy = Marshal.load Marshal.dump(opts)
      if clz.require_authorization?
        apply_authorization_header_to_opts! opts_copy
      end

      @client.send_request method, url, opts_copy
    end

    def apply_authorization_header_to_opts!(opts)
      headers = opts[:headers] || {}
      headers['Authorization'] = "Bearer #{@access_token}"
      opts[:headers] = headers
    end

  end

end
