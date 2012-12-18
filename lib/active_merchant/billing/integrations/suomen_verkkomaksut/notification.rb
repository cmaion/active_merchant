require 'net/http'
require 'date'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module SuomenVerkkomaksut
        # Parser and handler for incoming Automatic Payment Confirmations from SuomenVerkkomaksut.
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          include ActiveMerchant::PostsData

          def complete?
            status == 'Completed'
          end 

          def item_id
            params['ORDER_NUMBER']
          end

          def gross
            nil # not included in notification
          end

          def currency
            nil # not included in notification
          end

          def transaction_id
            params['PAID']
          end

          def status
            if transaction_id.blank?
              'Failed'
            else
              'Completed'
            end
          end
          
          def test?
            false
          end

          # Verify the received fingerprint
          def acknowledge
            if complete?
              p = params.clone
              return_md5_check_fields = [ :ORDER_NUMBER, :TIMESTAMP, :PAID, :METHOD ]
              aggregated_fields = ( return_md5_check_fields.map { |key| p[key.to_s] } + [ @options[:secret] ]).join('|')
              md5digest = Digest::MD5.hexdigest(aggregated_fields).upcase

              md5digest == params['RETURN_AUTHCODE']
            else
              true
            end
          end
        end
      end
    end
  end
end
