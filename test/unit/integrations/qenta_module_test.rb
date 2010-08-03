require 'test_helper'

class QentaModuleTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations
  
  def test_notification_method
    assert_instance_of Qenta::Notification, Qenta.notification('name=cody')
  end
  
  def test_return_method
    assert_instance_of Qenta::Return, Qenta.return('name=cody')
  end
end 
