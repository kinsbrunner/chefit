require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  def setup
    @chef = Chef.create!(chefname: 'Alejandro', email: 'alejandro@example.com', password: 'topsecret')
    @recipe = @chef.recipes.build(name: 'Chocolate cake', description: 'Great frozen cake based on cream and chocolate!')
    @ingredient = Ingredient.create(name: 'chocolate cover')
    @comment = Comment.new(description: 'I love chocolate cakes!', chef_id: @chef.id, recipe_id: nil)
  end
  
  test "recipe should be valid" do
    assert @recipe.valid?
  end

  test "recipe without chef should be invalid" do
    @recipe.chef_id = nil
    assert_not @recipe.valid?
  end
  
  test "name should be present" do
    @recipe.name = " "
    assert_not @recipe.valid?
  end

  test "description should be present" do
    @recipe.description = " "
    assert_not @recipe.valid?
  end
  
  test "description shouldn't be less than 5 characters" do
    @recipe.description = "a" * 3
    assert_not @recipe.valid?
  end
  
  test "description shouldn't be more than 500 characters" do
    @recipe.description = "a" * 501
    assert_not @recipe.valid? 
  end
  
  test "associated ingredients shouldn't be destroyed when deleting recipe" do
    @recipe.save
    @recipe.ingredients << @ingredient
    assert_no_difference 'Ingredient.count' do
      @recipe.destroy
    end
  end
  
  test "associated recipe-ingredients should be destroyed when deleting recipe" do
    @recipe.save
    @recipe.ingredients << @ingredient
    assert_difference "RecipeIngredient.count", -1 do
      @recipe.destroy
    end
  end

  test "associated comments should be destroyed when deleting a recipe" do
    @recipe.save
    @recipe.comments << @comment
    assert_difference "Comment.count", -1 do
      @recipe.destroy
    end
  end
end
