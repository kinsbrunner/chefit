require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create(chefname: 'Alejandro', email: 'alejandro@example.com', password: 'topsecret')
    @recipe = @chef.recipes.create(name: 'Pasta', description: 'The best italian pasta!')
    @comment = @recipe.comments.new
  end
  
  test "should create comment for recipe" do
    sign_in_as(@chef, 'topsecret')
    get recipe_path(@recipe)
    comment_description = 'This is the comment!'
    assert_difference 'Comment.count', 1 do
      post recipe_comments_path(@recipe), params: { comment: { description: comment_description } }
    end
    #follow_redirect!         # Removed as I introduced ActionCable
    #assert_not flash.empty?  # Removed as I introduced ActionCable
    assert_match comment_description, response.body
  end
    
  test "should reject comment posting" do
    sign_in_as(@chef, 'topsecret')
    get recipe_path(@recipe)
    @comment.chef = @chef
    assert_no_difference 'Comment.count' do
      post recipe_comments_path(@recipe), params: { comment: { description: '' } }
    end
    follow_redirect!
    assert_not flash.empty?
    assert_match 'No comments yet!', response.body
  end
end
