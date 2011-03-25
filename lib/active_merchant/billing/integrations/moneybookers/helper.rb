module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Moneybookers
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          def initialize(order, account, options = {})
            super
            add_field('merchant_fields', 'order_id, platform')
            add_field('platform', application_id.to_s) unless application_id.blank?
            add_field('hide_login', 1)
          end

          mapping :account, 'pay_to_email'
          mapping :order, [ 'transaction_id', 'order_id' ] # transaction_id is optional and disregarded by Moneybookers if over 32 characters (e.g. 36-char UUIDs)
          mapping :amount, 'amount'
          mapping :currency, 'currency'
          
          mapping :customer,
            :first_name => 'firstname',
            :last_name  => 'lastname',
            :email      => 'pay_from_email',
            :phone      => 'phone_number'

          mapping :billing_address,
            :city     => 'city',
            :address1 => 'address',
            :address2 => 'address2',
            :state    => 'state',
            :zip      => 'postal_code',
            :country  => 'country'

          mapping :notify_url, 'status_url'
          mapping :return_url, 'return_url'
          mapping :cancel_return_url, 'cancel_url'
          mapping :description, 'detail1_text'
          mapping :application_id, 'platform'
        end
      end
    end
  end
end
