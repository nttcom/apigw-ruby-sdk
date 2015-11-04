module ApiGW

  class Iam < ApiBase

    class << self
      def api_name
        'iam'
      end

      def require_authorization?
        true
      end
    end

    def get(path, opts = {})
      get_request path, opts
    end

    def post(path, data)
      opts_copy = {}
      opts_data = opts_copy[:data] || {}
      opts_copy[:data] = data
      post_request path, opts_copy
    end

    def put(path)
      put_request path
    end

    def delete(path)
      delete_request path
    end

    private

    def apply_service_name_to_opts(opts)
      opts_copy = Marshal.load Marshal.dump(opts)
      querys = opts_copy[:querys] || {}
      opts_copy[:querys] = querys
      return opts_copy
    end

  end
end
