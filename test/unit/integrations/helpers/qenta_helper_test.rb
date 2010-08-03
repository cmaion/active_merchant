require 'test_helper'

class QentaHelperTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations
  
  def setup
    @helper = Qenta::Helper.new('order-500', 'D200001', :amount => 567.89, :currency => 'EUR')
  end
 
  def test_basic_helper_fields
    assert_field 'customerId', 'D200001'
    assert_field 'amount', '567.89'
    assert_field 'currency', 'EUR'
    assert_field 'orderDescription', 'order-500'
    assert_field 'language', 'en'
  end

  def test_secret_should_not_be_added_to_the_fields
    old_fields_count = @helper.fields.size
    @helper.secret 'mysecret'
    assert_equal old_fields_count, @helper.fields.size
  end

  def test_unknown_mapping
    assert_nothing_raised do
      @helper.company_address :address => '500 Dwemthy Fox Road'
    end
  end
end
