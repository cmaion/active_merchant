module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Moneybooker
        autoload :Return, 'active_merchant/billing/integrations/moneybooker/return.rb'
        autoload :Helper, 'active_merchant/billing/integrations/moneybooker/helper.rb'
        autoload :Notification, 'active_merchant/billing/integrations/moneybooker/notification.rb'
        
        mattr_accessor :service_url
        self.service_url = 'https://www.moneybookers.com/app/payment.pl'
        
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
