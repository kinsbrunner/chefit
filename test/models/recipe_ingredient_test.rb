require 'test_helper'

class RecipeIngredientTest < ActiveSupport::TestCase
  def setup
    @chef = Chef.create!(chefname: 'Alejandro', email: 'alejandro@example.com', password: 'topsecret')
    @recipe = @chef.recipes.create(name: 'Chocolate cake', description: 'Great frozen cake based on cream and chocolate!')
    @ingredient = Ingredient.create(name: 'chocolate cover')
    @rec_ingr = RecipeIngredient.new(recipe: @recipe, ingredient: @ingredient)
  end
  
  test "Recipe-Ingredient should be valid" do
    assert @rec_ingr.valid?
  end

  test "recipe reference should be present" do
    @rec_ingr.recipe_id = nil
    assert_not @rec_ingr.valid?
  end

  test "recipe ingredient should be present" do
    @rec_ingr.ingredient_id = nil
    assert_not @rec_ingr.valid?
  end
end
