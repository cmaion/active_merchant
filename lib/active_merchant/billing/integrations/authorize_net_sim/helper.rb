module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module AuthorizeNetSim
        class Helper < ActiveMerchant::Billing::Integrations::Helper

          def initialize(order, account, options = {})
            super
            add_field('x_show_form', 'PAYMENT_FORM')
            add_field('x_relay_response', 'TRUE')
            add_field('x_delim_data', 'FALSE')
            add_field('x_version', '3.1')
            add_field('x_method', 'CC')
            add_field('test', 1) if ActiveMerchant::Billing::Base.integration_mode == :test
          end

          mapping :account, 'x_login'
          mapping :amount, 'x_amount'
          mapping :notify_url, 'x_relay_URL'
          mapping :description, 'x_description'
          mapping :customer, :first_name => 'x_first_name',
                              :last_name => 'x_last_name',
                              :email => 'x_email'
          mapping :shipping_address, :city => 'x_city',
                                      :address1 => 'x_address',
                                      :state => 'x_state',
                                      :zip => 'x_zip',
                                      :country => 'x_country'
          mapping :order, 'order_id'

          def secret(value)
            @secret = value
          end
          
          def form_fields
            @fields.merge(generate_request_finger_print)
          end

          def generate_request_finger_print
            x_fp_sequence = rand(99999)
            x_fp_timestamp = Time.now.to_i
            x_fp_hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('md5'), @secret, "#{@fields['x_login']}^#{x_fp_sequence}^#{x_fp_timestamp}^#{@fields['x_amount']}^")
            { 'x_fp_sequence' => x_fp_sequence,
              'x_fp_timestamp' => x_fp_timestamp,
              'x_fp_hash' => x_fp_hash
            }
          end
        end
      end
    end
  end
end
