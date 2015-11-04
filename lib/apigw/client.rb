# coding: utf-8

module ApiGW

  require 'apigw/logger'
  require 'yaml'
  require 'faraday'
  require 'faraday_middleware'

  class Client

    DEFAULT_CONFIG = {
      timeout: 30000,
      verify_ssl: false,
      debuggable: false
    }

    def initialize(opts = {})
      if opts.include?(:config_path) && opts.include?(:environment)
        # YAMLから取得したHashはキーがシンボルではなく文字列なので、キーをシンボルに直す必要あり
        cfg_all = YAML.load_file opts[:config_path]
        cfg = cfg_all[opts[:environment].to_s]
        cfg.keys.each do |key|
          cfg[key.to_sym] = cfg.delete key
        end
        config = cfg
      elsif opts.include?(:config)
        # こっちはキーがシンボルである想定
        config = opts[:config]
      else
        config = {}
      end

      @host = config[:host]
      if @host.nil?
        raise "Configuration 'host' is not found."
      end

      @api_version = config[:api_version]
      if @api_version.nil?
        raise "Configuration 'api_version' is not found."
      end

      @verify_ssl = config[:verify_ssl] || DEFAULT_CONFIG[:verify_ssl]
      @timeout = config[:timeout] || DEFAULT_CONFIG[:timeout]
      @debuggable = config[:debuggable] || DEFAULT_CONFIG[:debuggable]
    end

    def oauth(consumer_key, secret_key)
      ApiGW::OAuth.new self, consumer_key: consumer_key, secret_key: secret_key
    end

    def business_process(access_token)
      ApiGW::BusinessProcess.new self, access_token: access_token
    end

    def api_log(access_token)
      ApiGW::ApiLog.new self, access_token: access_token
    end

    def iam(access_token)
      ApiGW::Iam.new self, access_token: access_token
    end

    def send_request(method, path, opts = {})
      opts_copy = Marshal.load Marshal.dump(opts)
      querys = opts_copy[:querys]
      data = opts_copy[:data]
      headers = opts_copy[:headers] || {}

      headers[:accept] ||= "application/json"
      headers[:accept_encoding] ||= "gzip, deflate"
      headers[:connection] ||= "Keep-Alive"
      headers[:host] ||= @host.split("://")[1]

      unless method == :get
        if data
          headers[:content_length] ||= JSON.generate(data).length.to_s
        else
          headers[:content_length] ||= "0"
        end
      end

      headers[:user_agent] ||= "apigw/#{VERSION}"

      connection = Faraday.new("#{@host}/#{@api_version}") do |c|
        # 順番を変えると正しく動かないので順番を変えないこと
        c.request :json
        c.response :json
        if @debuggable
          # デバッグモード時はカスタムロガーとカスタムアダプターを使用
          c.use ApiGW::Logger
          c.use ApiGW::NetHttp
        else
          c.adapter :net_http
        end
        c.ssl.verify = @verify_ssl
      end

      # Faradayのタイムアウトは秒単位
      timeout_sec = @timeout / 1000
      response = connection.run_request method, path, data, headers do |r|
        r.params = querys unless querys.nil?
        r.options.timeout = timeout_sec
        r.options.open_timeout = timeout_sec
      end

      return response
    end

  end

end
