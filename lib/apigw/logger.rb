# coding: utf-8
module ApiGW

  require 'faraday'
  require 'json'

  class NetHttp < Faraday::Adapter::NetHttp
    # オーバーライドして :http_version と :message をenvに入れておく
    def perform_request(http, env)
      http_response = super
      env[:http_version] = http_response.http_version
      env[:message] = http_response.message
      http_response
    end
  end

  class Logger < Faraday::Response::Middleware

    def call(env)
      lines = [ "" ]
      if env.url.query.nil?
        path = env.url.path
      else
        path = "#{env.url.path}?#{env.url.query}"
      end
      lines << "#{env.method.upcase} #{path} HTTP/1.1"
      env.request_headers.keys.sort.each do |key|
        lines << "#{key}: #{env.request_headers[key]}"
      end
      lines << pretty_json(env.body)
      lines << ""

      @app.call(env).on_complete do
        lines << "HTTP/#{env[:http_version]} #{env.status} #{env[:message]}"
        env.response_headers.keys.sort.each do |key|
          lines << "#{key}: #{env.response_headers[key]}"
        end
        lines << pretty_json(env.body)
        puts lines.join "\n"
      end

    end

    private

    def pretty_json(input)
      if input.nil?
        return ''
      end
      begin
        # TODO inputがunicodeエスケープされててもパースされてしまう
        return JSON.pretty_generate(JSON.parse(input))
      rescue
        # pass
      end
      return input
    end

  end

end
