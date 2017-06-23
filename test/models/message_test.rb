require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    @chef = Chef.create(chefname: 'Alejandro', email: 'alejandro@example.com', password: 'topsecret')
    @message = @chef.messages.build(content: 'This is the sent message')
  end

  test "message should be valid" do
    assert @message.valid?
  end
    
  test "content should be present" do
    @message.content = ''
    assert_not @message.valid?
  end
end
