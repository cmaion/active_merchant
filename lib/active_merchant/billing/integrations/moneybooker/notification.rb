require 'net/http'
require 'date'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Moneybooker
        # Parser and handler for incoming Automatic Payment Confirmations from Moneybookers
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          include ActiveMerchant::PostsData

          def complete?
            status == 'Completed'
          end 

          def item_id
            params['order_id']
          end

          def transaction_id
            params['transaction_id']
          end

          def currency
            params['currency']
          end
  
          def gross
            params['amount']
          end

          def payment_state
            params['status']
          end

          def status
            case payment_state
            when '2'
              'Completed'
            when '0'
              'Pending'
            when '-1'
              'Voided'
            when '-2'
              'Failed'
            when '-3'
              'Chargeback'
            end
          end

          def test?
            !!params['test']
          end

          # Verify the received fingerprint
          def acknowledge
            if params['status'] == '2'
              md5sig = Digest::MD5.hexdigest("#{@options[:merchant_id]}#{transaction_id}#{Digest::MD5.hexdigest(@options[:secret_word]).upcase}#{params['mb_amount']}#{params['mb_currency']}#{params['status']}").upcase
              md5sig == params['md5sig'].upcase
            else
              true
            end
          end
        end
      end
    end
  end
end
