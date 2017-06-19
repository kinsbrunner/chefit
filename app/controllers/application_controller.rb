class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_chef, :logged_in?
  
  def current_chef
    @current_chef ||= Chef.find_by_id(session[:chef_id]) if session[:chef_id]
  end
  
  def logged_in?
    !!current_chef
  end
  
  def require_user
    if !logged_in?
      flash[:danger] = "You need to be logged in to access this functionality"
      redirect_to root_path
    end
  end

  def require_admin
    if !logged_in? || (logged_in? && !current_chef.admin?)
      flash[:danger] = "Only admin users can perform this action"
      redirect_to root_path
    end
  end
end
