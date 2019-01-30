class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :edit]
  
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
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
    @user.destroy
      
    flash[:success] = '退会しました'
    redirect_to root_url 
  end
  
  def user_params
   params.require(:user).permit(:name,:email,:password,:password_confirmation,:introduce,:image)
  end
end
