require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  def setup
    @chef = Chef.create!(chefname: 'Alejandro', email: 'alejandro@example.com', password: 'topsecret')
    @recipe = @chef.recipes.create(name: 'Chocolate cake', description: 'Great frozen cake based on cream and chocolate!')
    @ingredient = Ingredient.new(name: 'chocolate cover')
  end
  
  test "ingredient should be valid" do
    assert @ingredient.valid?
  end

  test "name should be present" do
    @ingredient.name = " "
    assert_not @ingredient.valid?
  end
  
  test "name shouldn't be less than 3 characters" do
    @ingredient.name = "a" * 2
    assert_not @ingredient.valid?
  end
  
  test "name shouldn't be more than 25 characters" do
    @ingredient.name = "a" * 27
    assert_not @ingredient.valid? 
  end
  
  test "name should be unique" do
    duplicate_ingr = @ingredient.dup
    duplicate_ingr.name = @ingredient.name
    @ingredient.save
    assert_not duplicate_ingr.valid?
  end
  
  test "associated recipes shouldn't be destroyed when deleting ingredient" do
    @ingredient.save
    @recipe.ingredients << @ingredient
    assert_no_difference 'Recipe.count' do
      @ingredient.destroy
    end
  end
  
  test "associated recipe-ingredients should be destroyed when deleting ingredient" do
    @recipe.save
    @recipe.ingredients << @ingredient
    assert_difference "RecipeIngredient.count", -1 do
      @recipe.destroy
    end
  end
end
