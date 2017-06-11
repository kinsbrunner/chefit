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
  end
  
  test "should create new valid recipe" do
    get new_recipe_path
    assert_template 'recipes/new'
    name_of_recipe = 'Spaghetti with tomatoe sauce'
    description_of_recipe = 'boil water, add pasta, warm up sauce and serve 
                             with melted cheese'
    assert_difference 'Recipe.count', 1 do
      post recipes_path, params: { recipe: { name: name_of_recipe, description: description_of_recipe } }
    end
    follow_redirect!
    assert_match name_of_recipe.capitalize, response.body
    #assert_match description_of_recipe, response.body
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
end
