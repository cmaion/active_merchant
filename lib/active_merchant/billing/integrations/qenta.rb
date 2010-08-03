module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Qenta
        autoload :Return, 'active_merchant/billing/integrations/qenta/return.rb'
        autoload :Helper, 'active_merchant/billing/integrations/qenta/helper.rb'
        autoload :Notification, 'active_merchant/billing/integrations/qenta/notification.rb'
        
        mattr_accessor :service_url
        self.service_url = 'https://www.qenta.com/qpay/init.php'
        
        def self.notification(post)
          Notification.new(post)
        end
        
        def self.return(query_string)
          Return.new(query_string)
        end
      end
    end
  end
end
