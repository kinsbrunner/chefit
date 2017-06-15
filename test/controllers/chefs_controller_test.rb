require 'test_helper'

class ChefsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create(chefname: 'Alejandro', email: 'alejandro@example.com', password: 'topsecret', password_confirmation: 'topsecret')
    @recipe1 = @chef.recipes.create(name: 'Pasta', description: 'The best italian pasta!')
    @recipe2 = @chef.recipes.create(name: 'Barbecue', description: 'The real argentinian receipe!')
  end
  
  test "should get signup path" do
    get signup_path
    assert_response :success
  end

  test "should reject an invalid signup" do
    get signup_path
    assert_template 'chefs/new'
    assert_no_difference 'Chef.count' do
      post chefs_path, params: { chef: { chefname: '', email: '', password: '', password_confirmation: '' } }
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
      post chefs_path, params: { chef: { chefname: 'John', email: 'john@example.com',
                                         password: 'topsecret', password_confirmation: 'topsecret' } }
    end
    follow_redirect!
    assert_template 'chefs/show'
    assert_not flash.empty?
  end
  
  test "should get chef's show" do
    get chef_path(@chef)
    assert_template 'chefs/show'
    assert_select "a[href=?]", recipe_path(@recipe1), text: @recipe1.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
    assert_match @recipe1.description, response.body
    assert_match @recipe2.description, response.body
    assert_match @chef.chefname, response.body
  end
end
