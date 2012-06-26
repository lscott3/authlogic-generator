class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  def new
    render
  end
  
  def edit
    render
  end
  
  def update
    if @user.save
      flash[:notice] = "Password Updated"
      redirect_to users_url
    else
      render :action => :edit
    end
  end
  
  def create
    @user = User.find_by_email(params[:email])
    if @user
      flash[:notice] = "Password has been reset."
      render :action => 'new'
    else
      flash[:notice] = "Error your password has not been reset."
      render :action => 'new'
    end
  end
  
  private
  
  def load_user_using_perishable_token
    @user = User.find_by_perishable_token(params[:id])
    unless @user
      flash[:notice] = "That user could not be found. If you are having trouble, try copying and pasting the URL from the email that was sent."
      redirect_to password_resets_url
    end
  end  
end
