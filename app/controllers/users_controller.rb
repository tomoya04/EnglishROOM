class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :edit,:followings,:followers,:like]
  before_action :correct_user, only: [:edit,:update,:destroy]
  def index
    @users = User.all.page(params[:page])
    if params[:name].present? 
      @users = @users.get_by_name params[:name]
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order("created_at DESC").page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = "User has signed up"
      redirect_to @user
    else
      flash.now[:danger]= "Failed to sign up"
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if current_user == @user
    
      if @user.update(user_params)
        flash[:success] = "Edited user"
        redirect_to @user
      else 
        flash.now[:danger]= "Failed to user"
        render :edit
      end 
    end
  end

  

  def destroy
    @user = User.find(params[:id])
    
    session[:user_id] = nil
    @user.destroy
    flash[:success] = "unsubscribed"
    redirect_to root_url 
  end
  
  def followings 
    @user = User.find(params[:id])
    @users = @user.followings.page(params[:page])
   
  end
  
  def followers
    @user = User.find(params[:id])
    @users = @user.followers.page(params[:page])
  end
  
  def like
    @user = User.find(params[:id])
    @fav_posts = @user.fav_posts.order("created_at DESC").page(params[:page])
    counts(@user)
  end
  
  private
  
  def user_params
   params.require(:user).permit(:name,:email,:password,:password_confirmation,:introduce,:image)
  end
  
  def correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to root_url 
    end
  end
end
