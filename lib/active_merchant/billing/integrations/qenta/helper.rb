module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Qenta
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          mapping :account, 'customerId'
          mapping :amount, 'amount'
          mapping :order, [ 'orderDescription', 'order_id' ]

          def initialize(order, account, options = {})
            super
            add_field('test', 1) if account == 'D200001'
            add_field('language', 'en')
            add_field('paymenttype', 'CCARD')
          end

          def secret(value)
            @secret = value
          end
          
          mapping :description, 'displayText'
          mapping :currency, 'currency'
          mapping :notify_url, 'confirmURL'
          mapping :return_url, 'successURL'
          mapping :cancel_return_url, [ 'cancelURL', 'failureURL' ]
          mapping :logo, 'imageURL'
          mapping :contact_url, 'serviceURL'
          mapping :window_name, 'windowName'
          mapping :secret, 'secret'

          def form_fields
            @fields.merge(generate_request_finger_print)
          end

          MD5_CHECK_FIELDS = [ :customerId, :amount, :currency, :language, :orderDescription, :displayText, :successURL, :confirmURL ]

          def generate_request_finger_print
            order = ([ :secret ] + MD5_CHECK_FIELDS + [ :requestFingerprintOrder ] ).join(',')
            md5digest = Digest::MD5.hexdigest(@secret + MD5_CHECK_FIELDS.map { |key| @fields[key.to_s] }.join + order)
            {
              'requestFingerprintOrder' => order,
              'requestfingerprint' => md5digest
            }
          end
        end
      end
    end
  end
end
