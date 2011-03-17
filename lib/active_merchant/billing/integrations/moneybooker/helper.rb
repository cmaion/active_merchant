module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Moneybooker
        class Helper < ActiveMerchant::Billing::Integrations::Helper

          def initialize(order, account, options = {})
            super
            add_field('merchant_fields', 'order_id,platform')
            add_field('language', 'EN')
            add_field('hide_login', 1)
            add_field('platform', 'PhotoDeck')
          end

          mapping :account, 'pay_to_email'
          mapping :description, 'recipient_description'
          mapping :amount, 'amount'
          mapping :currency, 'currency'
          mapping :order, 'order_id'
          mapping :customer, :first_name => 'firstname',
                              :last_name => 'lastname',
                              :email => 'pay_from_email'
          mapping :shipping_address, :city => 'city',
                                      :address1 => 'address',
                                      :state => 'state',
                                      :zip => 'postal_code',
                                      :country => 'country'
          mapping :notify_url, 'status_url'
          mapping :return_url, 'return_url'
          mapping :cancel_return_url, 'cancel_url'

          def form_fields
            @fields.merge(generate_transaction_id)
          end

          def generate_transaction_id
            # used to authorize notification
            { 'transaction_id' => @fields['order_id'].gsub('-','') } # max 32 chars => uuid without dashes
          end
        end
      end
    end
  end
end
