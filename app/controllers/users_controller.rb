class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :edit]
  
  def index
    @users = User.all.page(params[:page])
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
      flash[:success] = "ユーザーを登録しました"
      redirect_to @user
    else
      flash.now[:danger]= "ユーザーを登録できませんでした"
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
        flash[:success] = "ユーザーを編集しました"
        redirect_to @user
      else 
        flash.now[:danger]= "ユーザーを編集できませんでした"
        render :edit
      end 
    end
  end

  

  def destroy
    @user = User.find(params[:id])
    
    session[:user_id] = nil
    @user.destroy
    flash[:success] = '退会しました'
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
  
  private
  
  def user_params
   params.require(:user).permit(:name,:email,:password,:password_confirmation,:introduce,:image)
  end
end
