require 'test_helper'

class RecipesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create(chefname: 'Alejandro', email: 'alejandro@example.com')
    @recipe1 = @chef.recipes.create(name: 'Pasta', description: 'The best italian pasta!')
    @recipe2 = @chef.recipes.create(name: 'Barbecue', description: 'The real argentinian receipe!')
  end
  
  test "should get recipes index" do
    get recipes_path
    assert_response :success
  end
  
  test "should get recipes listing" do
    get recipes_path
    assert_template 'recipes/index'
    assert_select "a[href=?]", recipe_path(@recipe1), text: @recipe1.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
  end
  
  test "should get recipe show" do
    get recipe_path(@recipe1)
    assert_template 'recipes/show'
    assert_match @recipe1.name, response.body
    assert_match @recipe1.description, response.body
    assert_match @chef.chefname, response.body
    assert_select "a[href=?]", edit_recipe_path(@recipe1), text: 'Edit Recipe'
    assert_select "a[href=?]", recipe_path(@recipe1), text: 'Delete Recipe'
  end
  
  test "should create new valid recipe" do
    get new_recipe_path
    assert_template 'recipes/new'
    name_of_recipe = 'Spaghetti with tomatoe sauce'
    description_of_recipe = 'boil water, add pasta, warm up sauce and serve with melted cheese'
    assert_difference 'Recipe.count', 1 do
      post recipes_path, params: { recipe: { name: name_of_recipe, description: description_of_recipe } }
    end
    follow_redirect!
    assert_match name_of_recipe.capitalize, response.body
    assert_match description_of_recipe, response.body
  end
  
  test "should reject invalid recipe submissions" do
    get new_recipe_path
    assert_template 'recipes/new'
    assert_no_difference 'Recipe.count' do
      post recipes_path, params: { recipe: { name: '', description: '' } }
    end
    assert_template 'recipes/new'
    assert_select 'div.alert-danger'
    assert_select 'div.has-error'
    assert_select 'span.help-block'
  end
  
  test "should reject invalid recipe update" do
    get edit_recipe_path(@recipe1)
    assert_template 'recipes/edit'
    patch recipe_path(@recipe1), params: { recipe: { name: '', description: 'some description' } }
    assert_template 'recipes/edit'
    assert_select 'div.alert-danger'
    assert_select 'div.has-error'
    assert_select 'span.help-block'
    
  end
  
  test "should succesfully edit a recipe" do
    get edit_recipe_path(@recipe1)
    assert_template 'recipes/edit'
    updated_name = 'updated recipe name'
    updated_description = 'updated recipe description'
    patch recipe_path(@recipe1), params: { recipe: { name: updated_name, description: updated_description } }
    assert_redirected_to @recipe1
    #follow_redirect!
    assert_not flash.empty?
    @recipe1.reload
    assert_match updated_name, @recipe1.name
    assert_match updated_description, @recipe1.description
  end
  
  test "should succesfully delete a recipes" do
    get recipe_path(@recipe1)
    assert_template 'recipes/show'
    assert_select "a[href=?]", recipe_path(@recipe1), text: 'Delete Recipe'
    assert_difference "Recipe.count", -1 do
      delete recipe_path(@recipe1)
    end
    assert_redirected_to recipes_path
    assert_not flash.empty?
   
  end
end
