class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end
  
  def show
    @recipe = Recipe.find_by_id(params[:id])
  end
  
  def new
    @recipe = Recipe.new    
  end
  
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.chef = Chef.first # this is temp until I add login and user related actions
    if @recipe.save
      flash[:success] = "Recipe was created successfully!"
      redirect_to recipe_path(@recipe)
    else
      render 'new'
    end
  end
  
  def edit
    @recipe = Recipe.find_by_id(params[:id])
  end
  
  def update
    @recipe = Recipe.find_by_id(params[:id])
    if @recipe.update(recipe_params)
      flash[:success] = "Recipe was created successfully!"
      redirect_to recipe_path(@recipe)
    else
      render 'edit'
    end
  end
  
  def destroy
    @recipe = Recipe.find_by_id(params[:id])
    @recipe.destroy
    flash[:success] = "Recipe was deleted successfully!"
    redirect_to recipes_path
  end
  
  private
  
  def recipe_params
    params.require(:recipe).permit(:name, :description)
  end
end
