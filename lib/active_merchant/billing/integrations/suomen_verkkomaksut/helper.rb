module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module SuomenVerkkomaksut
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          mapping :account, 'MERCHANT_ID'
          mapping :amount, 'AMOUNT'
          mapping :order, [ 'ORDER_NUMBER' ]

          def initialize(order, account, options = {})
            super
            add_field('TYPE', 'S1')
          end

          def secret(value)
            @secret = value
          end

          mapping :description, 'ORDER_DESCRIPTION'
          mapping :currency, 'CURRENCY'
          mapping :notify_url, 'NOTIFY_ADDRESS'
          mapping :return_url, 'RETURN_ADDRESS'
          mapping :cancel_return_url, 'CANCEL_ADDRESS'

          def form_fields
            @fields.merge(generate_request_finger_print)
          end

          MD5_CHECK_FIELDS = [ :MERCHANT_ID, :AMOUNT, :ORDER_NUMBER, :REFERENCE_NUMBER, :ORDER_DESCRIPTION, :CURRENCY, :RETURN_ADDRESS, :CANCEL_ADDRESS, :PENDING_ADDRESS, :NOTIFY_ADDRESS, :TYPE, :CULTURE, :PRESELECTED_METHOD, :MODE, :VISIBLE_METHODS, :GROUP ]

          def generate_request_finger_print
            aggregated_fields = ( [ @secret ] + MD5_CHECK_FIELDS.map { |key| @fields[key.to_s] }).join('|')
            md5digest = Digest::MD5.hexdigest(aggregated_fields).upcase
            { 'AUTHCODE' => md5digest }
          end
        end
      end
    end
  end
end
