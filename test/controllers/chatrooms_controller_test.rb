require 'test_helper'

class ChatroomsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create(chefname: 'Alejandro', email: 'alejandro@example.com', password: 'topsecret')
    @message_existing = @chef.messages.create(content: 'Old message')
    @message_erroneous = @chef.messages.new(content: '')
    @message = @chef.messages.new
    @messages = [@message_existing]
  end
  
  test "should create message on ChatRoom" do
    sign_in_as(@chef, 'topsecret')
    get chat_path
    assert_template 'chatrooms/show'
    assert_template partial: '_messages'
    message_chat = 'This is a message posted on chat!'
    assert_difference 'Message.count', 1 do
      post messages_path, params: { message: { content: message_chat } }
    end
    #follow_redirect!         # Removed as I introduced ActionCable
    #assert_not flash.empty?  # Removed as I introduced ActionCable
    assert_match message_chat, response.body
  end
    
  test "should reject empty message posting" do
    sign_in_as(@chef, 'topsecret')
    get chat_path
    assert_template 'chatrooms/show'
    assert_template partial: '_messages'
    assert_no_difference 'Message.count' do
      post messages_path, params: { message: { content: @message_erroneous.content } }
    end
  end
end
