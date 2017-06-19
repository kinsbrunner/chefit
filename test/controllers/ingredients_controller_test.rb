require 'test_helper'

class IngredientsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @ingredient1 = Ingredient.create(name: 'Chocolate')
    @ingredient2 = Ingredient.create(name: 'Banana')
    @chef = Chef.create(chefname: 'Alejandro', email: 'alejandro@example.com', password: 'topsecret', password_confirmation: 'topsecret')
    @chef_admin = Chef.create(chefname: 'John', email: 'john@example.com', password: 'topsecret', password_confirmation: 'topsecret', admin: true)
    @recipe = @chef.recipes.create(name: 'Pasta', description: 'The best italian pasta!')
    @RecIng = RecipeIngredient.create(recipe_id: @recipe.id, ingredient_id: @ingredient1.id)
  end
  
  test "should get ingredients index" do
    get ingredients_path
    assert_response :success
  end
  
  test "should get ingredients listing" do
    get ingredients_path
    assert_template 'ingredients/index'
    assert_select "a[href=?]", ingredient_path(@ingredient1), text: @ingredient1.name.capitalize
    assert_select "a[href=?]", ingredient_path(@ingredient2), text: @ingredient2.name.capitalize
  end

  test "should get ingredient's show" do
    get ingredient_path(@ingredient1)
    assert_template 'ingredients/show'
    assert_match @ingredient1.name, response.body
    assert_match @recipe.name, response.body
    assert_match @recipe.description, response.body
  end

  test "should create new valid ingredient" do
    sign_in_as(@chef_admin, 'topsecret')
    get new_ingredient_path
    assert_template 'ingredients/new'
    assert_difference 'Ingredient.count', 1 do
      post ingredients_path, params: { ingredient: { name: 'Garlic' } }
    end
    follow_redirect!
    assert_match 'Garlic', response.body
    assert_match 'No recipes contain this ingredient', response.body
  end
  
  test "should reject invalid ingredient submissions" do
    sign_in_as(@chef_admin, 'topsecret')
    get new_ingredient_path
    assert_template 'ingredients/new'
    assert_no_difference 'Ingredient.count' do
      post ingredients_path, params: { ingredient: { name: '' } }
    end
    assert_template 'ingredients/new'
    assert_select 'div.alert-danger'
    assert_select 'div.has-error'
    assert_select 'span.help-block'
  end

  test "should reject non admin users to create an ingredient" do
    sign_in_as(@chef, 'topsecret')
    assert_no_difference 'Ingredient.count' do
      post ingredients_path, params: { ingredient: { name: 'Garlic' } }
    end
    assert_redirected_to root_path
    assert_not flash.empty?
  end

  test "should reject invalid ingredient update" do
    sign_in_as(@chef_admin, 'topsecret')
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    patch recipe_path(@recipe), params: { recipe: { name: '', description: 'some description' } }
    assert_template 'recipes/edit'
    assert_select 'div.alert-danger'
    assert_select 'div.has-error'
    assert_select 'span.help-block'
  end
  
  test "should succesfully edit a recipe" do
    sign_in_as(@chef_admin, 'topsecret')
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    updated_name = 'updated recipe name'
    updated_description = 'updated recipe description'
    patch recipe_path(@recipe), params: { recipe: { name: updated_name, description: updated_description } }
    assert_redirected_to @recipe
    assert_not flash.empty?
    @recipe.reload
    assert_match updated_name, @recipe.name
    assert_match updated_description, @recipe.description
  end
  
  test "should reject non admin users to edit ingredient" do
    sign_in_as(@chef, 'topsecret')
    assert_no_difference 'Ingredient.count' do
      patch ingredient_path(@ingredient1), params: { ingredient: { name: 'Potatoe' } }
    end
    assert_redirected_to root_path
    assert_not flash.empty?
    @ingredient1.reload
    assert_match 'Chocolate', @ingredient1.name
  end
end
