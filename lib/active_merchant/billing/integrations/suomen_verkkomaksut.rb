module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module SuomenVerkkomaksut
        autoload :Return, 'active_merchant/billing/integrations/suomen_verkkomaksut/return.rb'
        autoload :Helper, 'active_merchant/billing/integrations/suomen_verkkomaksut/helper.rb'
        autoload :Notification, 'active_merchant/billing/integrations/suomen_verkkomaksut/notification.rb'
        
        mattr_accessor :service_url
        self.service_url = 'https://payment.verkkomaksut.fi/'
        
        def self.notification(params)
          Notification.new(params)
        end
        
        def self.return(query_string)
          Return.new(query_string)
        end
      end
    end
  end
end
