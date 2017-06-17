require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @chef = Chef.create!(chefname: 'Alejandro', email: 'alejandro@example.com', password: 'topsecret')
    @recipe = @chef.recipes.create(name: 'Chocolate cake', description: 'Great frozen cake based on cream and chocolate!')
    @comment = Comment.new(description: 'I love chocolate cakes!', chef_id: @chef.id, recipe_id: @recipe.id)
  end
  
  test "comment should be valid" do
    assert @comment.valid?
  end

  test "description should be present" do
    @comment.description = " "
    assert_not @comment.valid?
  end

  test "description shouldn't be less than 4 characters" do
    @comment.description = "a" * 3
    assert_not @comment.valid?
  end

  test "description shouldn't be more than 140 characters" do
    @comment.description = "a" * 141
    assert_not @comment.valid? 
  end

  test "recipe_id should be present" do
    @comment.recipe_id = nil
    assert_not @comment.valid?
  end

  test "chef_id should be present" do
    @comment.chef_id = nil
    assert_not @comment.valid?
  end
end
