require 'test_helper'

class QentaNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    @qpay = Qenta::Notification.new(http_raw_data, :secret => "mysecret")
  end

  def test_accessors
    assert @qpay.complete?
    assert_equal "Completed", @qpay.status
    assert_equal "14714790", @qpay.transaction_id
    assert_equal "order-123", @qpay.item_id
    assert_equal "29.88", @qpay.gross
    assert_equal "EUR", @qpay.currency
    assert @qpay.test?
  end

  def test_compositions
    assert_equal Money.new(2988, 'EUR'), @qpay.amount
  end

  def test_acknowledgement    
    assert @qpay.acknowledge
  end
  
  def test_failed_acknowledgement
    @qpay = Qenta::Notification.new(http_raw_data, :secret => "badsecret")
    assert !@qpay.acknowledge
  end

  def test_qpay_attributes
    assert_equal "SUCCESS", @qpay.payment_state
  end

  def test_respond_to_acknowledge
    assert @qpay.respond_to?(:acknowledge)
  end

  private
  def http_raw_data
    "amount=29.88&currency=EUR&paymentType=CCARD&financialInstitution=MC&language=en&orderNumber=14714790&paymentState=SUCCESS&authenticity_token=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX&commit=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX&order_id=order-123&test=1&authenticated=No&anonymousPan=0002&expiry=12%2F2010&responseFingerprintOrder=amount%2Ccurrency%2CpaymentType%2CfinancialInstitution%2Clanguage%2CorderNumber%2CpaymentState%2Cauthenticity_token%2Ccommit%2Corder_id%2Ctest%2Cauthenticated%2CanonymousPan%2Cexpiry%2Csecret%2CresponseFingerprintOrder&responseFingerprint=2a2a1147ddfb653184080f1d8230e607&"
  end  
end
