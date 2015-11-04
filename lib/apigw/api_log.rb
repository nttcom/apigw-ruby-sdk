module ApiGW

  class ApiLog < ApiBase

    class << self
      def api_name
        'apilog'
      end

      def require_authorization?
        true
      end
    end

    def get(target_date)
     querys = {
        targetDate: target_date
      }
      get_request nil, querys: querys
    end

  end

end
