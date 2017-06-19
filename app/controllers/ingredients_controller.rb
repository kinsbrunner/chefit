class IngredientsController < ApplicationController
  before_action :current_ingredient, only: [:show, :edit, :update]
  before_action :require_admin, except: [:index, :show]
  
  def index
    @ingredients = Ingredient.paginate(page: params[:page], per_page: 5)
  end
  
  def show
    @recipes_with_ingredient = @ingredient.recipes.paginate(page: params[:page], per_page: 5) if @ingredient
  end
  
  def new
    @ingredient = Ingredient.new
  end
  
  def create
    @ingredient = Ingredient.new(ingredient_params)
    if @ingredient.save
      flash[:success] = "ingredient was created successfully!"
      redirect_to ingredient_path(@ingredient)
    else
      render :new
    end
  end
  
  def edit  
  end
  
  def update
    if @ingredient.update(ingredient_params)
      flash[:success] = "Ingredient was updated successfully!"
      redirect_to ingredient_path(@ingredient)
    else
      render :edit
    end
  end
  
  private
  
  def current_ingredient
    @ingredient = Ingredient.find_by_id(params[:id])
  end

  def ingredient_params
    params.require(:ingredient).permit(:name)
  end
end
