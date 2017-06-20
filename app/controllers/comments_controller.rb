class CommentsController < ApplicationController
  before_action :require_user
  
  def create
    @recipe = Recipe.find_by_id(params[:recipe_id])
    @comment = @recipe.comments.build(comment_params)
    @comment.chef = current_chef
    if @comment.save
      flash[:success] = "Comment was created successfully"
    else
      flash[:danger] = "Comment was not posted"
    end
    redirect_to recipe_path(@recipe)
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:description)
  end
end
