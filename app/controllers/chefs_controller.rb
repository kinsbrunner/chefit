class ChefsController < ApplicationController
  before_action :current_chef, only: [:show, :edit, :update, :destroy]

  def index
    @chefs = Chef.paginate(page: params[:page], per_page: 5)
  end
  
  def new
    @chef = Chef.new
  end
  
  def create
    @chef = Chef.new(chef_params)
    if @chef.save
      flash[:success] = "Welcome #{@chef.chefname} to Chefit!"
      redirect_to chef_path(@chef)
    else
      render :new
    end
  end
  
  def show
    @chef_recipes = @chef.recipes.paginate(page: params[:page], per_page: 5)
  end
  
  def edit
  end
  
  def update
    if @chef.update(chef_params)
      flash[:success] = "Your account was updated successfully!"
      redirect_to @chef
    else
      render :edit
    end
  end  
  
  def destroy
    @chef.destroy
    flash[:danger] = "The chef has been deleted with all its associated recipes!"
    redirect_to chefs_path
  end
    
  private

  def current_chef
    @chef = Chef.find_by_id(params[:id])
  end
  
  def chef_params
    params.require(:chef).permit(:chefname, :email, :password, :password_confirmation)
  end
end
