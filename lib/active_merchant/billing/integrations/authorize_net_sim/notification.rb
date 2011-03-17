require 'net/http'
require 'date'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module AuthorizeNetSim
        # Parser and handler for incoming Automatic Payment Confirmations from Authorize.Net
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          include ActiveMerchant::PostsData

          def complete?
            status == 'Completed'
          end 

          def item_id
            params['order_id']
          end

          def transaction_id
            params['x_trans_id']
          end

          def currency
            'USD'
          end
  
          def gross
            params['x_amount']
          end

          def payment_state
            params['x_response_code']
          end

          def status
            case payment_state
            when '1'
              'Completed'
            when '2'
              'Denied'
            when '3'
              'Failed'
            when '4'
              'Held for Review'
            end
          end

          def test?
            !!params['test']
          end

          # Verify the received fingerprint
          def acknowledge
            if params['x_response_code'] == '1'
              md5digest = Digest::MD5.hexdigest("#{@options[:md5_hash]}#{@options[:login]}#{transaction_id}#{gross}").upcase
              md5digest == params['x_MD5_Hash'].upcase
            else
              true
            end
          end
        end
      end
    end
  end
end
