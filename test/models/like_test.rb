require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
    @chef = Chef.create!(chefname: 'Alejandro', email: 'alejandro@example.com', password: 'topsecret')
    @recipe = @chef.recipes.create(name: 'Chocolate cake', description: 'Great frozen cake based on cream and chocolate!')
    @like = Like.new(like: true, chef_id: @chef.id, recipe_id: @recipe.id)
  end
  
  test "like should be valid" do
    assert @like.valid?
  end

  test "recipe_id should be present" do
    @like.recipe_id = nil
    assert_not @like.valid?
  end

  test "chef_id should be present" do
    @like.chef_id = nil
    assert_not @like.valid?
  end

  test "like/dislike should be unique from a specific chef for a specific recipe" do
    duplicate_like = @like.dup
    @like.save
    assert_not duplicate_like.valid?
  end
end
