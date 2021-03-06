require 'test_helper'

class ChefTest < ActiveSupport::TestCase
  def setup
    @chef = Chef.new(chefname: 'Alejandro', email: 'alejandro@example.com', password: 'topsecret')
    @chef2 = Chef.create(chefname: 'Peter', email: 'peter@example.com', password: 'topsecret')
    @recipe = @chef2.recipes.create(name: 'Chocolate cake', description: 'Great frozen cake based on cream and chocolate!')
    @comment = @chef2.comments.create(description: 'I love chocolate cakes!', recipe_id: @recipe.id)
    @like = @recipe.likes.create(like: true, chef_id: @chef2.id)
  end

  test "chef should be valid" do
    assert @chef.valid?
  end
  
  test "chefname should be present" do
    @chef.chefname = " "
    assert_not @chef.valid?
  end
  
  test "chefname should be less than 30 characters" do
    @chef.chefname = "a" * 31
    assert_not @chef.valid?
  end
  
  test "email should be present" do
    @chef.email = " "
    assert_not @chef.valid?
  end

  test "email should be less than 50 characters" do
    @chef.email = "a" * 51
    assert_not @chef.valid?
  end
  
  test "email should accept correct format" do
    valid_emails = %w[user@example.com ALEJANDRO@gmail.com A.first@yahoo.ca peter+green@co.uk.org]
    valid_emails.each do |valids|
      @chef.email = valids
      assert @chef.valid?, "#{valids.inspect} should be valid"
    end
  end
  
  test "should reject invalid addresses" do
    invalid_emails = %w[alex@example alex@example,com alex.name@gmail. john@foo+bar.com]
    invalid_emails.each do |invalids|
      @chef.email = invalids
      assert_not @chef.valid?, "#{invalids.inspect} should be invalid"
    end
  end 
  
  test "email should be unique and case insensitive" do
    duplicate_chef = @chef.dup
    duplicate_chef.email = @chef.email.upcase
    @chef.save
    assert_not duplicate_chef.valid?
  end
  
  test "email should be lower case before hitting the db" do
    mixed_email = "ALEJANDRO@Example.com"
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end
  
  test "password should be present" do
    @chef.password = @chef.password_confirmation = ''
    assert_not @chef.valid?
  end

  test "password should have at least 5 characters" do
    @chef.password = "a" * 4
    assert_not @chef.valid?
  end
  
  test "associated recipes should be destroyed" do
    @chef.save
    @chef.recipes.create(name: 'testing destroy', description: 'recipe to be destroyed')
    assert_difference 'Recipe.count', -1 do
      @chef.destroy
    end
  end

  test "associated comments should be destroyed when deleting a chef" do
    assert_difference "Comment.count", -1 do
      @chef2.destroy
    end
  end

  test "associated messages should be destroyed" do
    @chef.save
    @chef.messages.create(content: 'This is the message to be deleted')
    assert_difference 'Message.count', -1 do
      @chef.destroy
    end
  end
  
  test "associated likes should be destroyed when deleting a chef" do
    assert_difference "Like.count", -1 do
      @chef2.destroy
    end
  end
end
