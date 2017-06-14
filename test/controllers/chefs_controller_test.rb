require 'test_helper'

class ChefsControllerTest < ActionDispatch::IntegrationTest
  test "should get signup path" do
    get signup_path
    assert_response :success
  end

  test "should reject an invalid signup" do
    get signup_path
    assert_template 'chefs/new'
    assert_no_difference 'Chef.count' do
      post chefs_path, params: { chef: { chefname: '', email: '', password: '' } }
    end
    assert_template 'chefs/new'
    assert_select 'div.alert-danger'
    assert_select 'div.has-error'
    assert_select 'span.help-block'
  end
  
  test "should accept valid signup" do
    get signup_path
    assert_template 'chefs/new'
    assert_difference 'Chef.count', 1 do
      post chefs_path, params: { chef: { chefname: 'Alejandro', email: 'alejandro@example.com',
                                         password: 'topsecret', password_confirmation: 'topsecret' } }
    end
    follow_redirect!
    assert_template 'chefs/show'
    assert_not flash.empty?
  end
end
