require 'net/http'
require 'date'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Qenta
        # Parser and handler for incoming Automatic Payment Confirmations from Qenta.
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          include ActiveMerchant::PostsData

          def complete?
            status == 'Completed'
          end 

          def item_id
            params['order_id']
          end

          def transaction_id
            params['orderNumber']
          end

          def currency
            params['currency']
          end
  
          def gross
            params['amount']
          end

          def payment_state
            params['paymentState']
          end

          def status
            case payment_state
            when 'SUCCESS'
              'Completed'
            when 'CANCEL'
              'Voided'
            else
              'Failed'
            end
          end

          def test?
            !!params['test']
          end

          # Verify the received fingerprint
          def acknowledge
            if params['paymentState'] == 'SUCCESS'
              p = params.clone
              p['secret'] = @options[:secret]
              md5digest = Digest::MD5.hexdigest(p['responseFingerprintOrder'].split(',').map { |key| p[key] }.join)

              md5digest == params['responseFingerprint']
            else
              true
            end
          end
        end
      end
    end
  end
end
