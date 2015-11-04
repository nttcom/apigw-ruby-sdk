module ApiGW

  class BusinessProcess < ApiBase

    class << self
      def api_name
        'business-process'
      end

      def require_authorization?
        true
      end
    end

    def get(path, service_name, opts = {})
      get_request path, apply_service_name_to_opts(opts, service_name)
    end

    def post(path, service_name, data, opts = {})
      opts_copy = Marshal.load Marshal.dump(opts)
      opts_data = opts_copy[:data] || {}
      opts_copy[:data] = opts_data.merge data
      post_request path, apply_service_name_to_opts(opts_copy, service_name)
    end

    private

    def apply_service_name_to_opts(opts, service_name)
      opts_copy = Marshal.load Marshal.dump(opts)
      querys = opts_copy[:querys] || {}
      querys['serviceName'] = service_name
      opts_copy[:querys] = querys
      return opts_copy
    end

  end
end
