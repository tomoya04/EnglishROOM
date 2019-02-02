class PostsController < ApplicationController
  before_action :require_user_logged_in 
  before_action :correct_user, only: [:destroy]
  
  def show
    @post = Post.find(params[:id])
    @comment = Comment.new(post_id: @post.id)
    @comments = @post.comments
   
  end

  def new
    if logged_in?
      @post = current_user.posts.build
    end 
  end
  
  def create
    @post = current_user.posts.build(post_params)
    
    if @post.save
      flash[:success]= "投稿しました"
      redirect_to root_url
    else
      @posts = current_user.feed_posts.order('created_at DESC').page(params[:page])
      flash.now[:danger]="投稿に失敗しました"
      render "toppages/index"
    end
  end 

  def edit
    @post = current_user.posts.find_by(id: params[:id])
  end

  def update
   @post = current_user.posts.find_by(id: params[:id])
    
   
    
    if  @post.update(post_params)
      flash[:success] = "投稿を編集しました"
      redirect_to @post
    else
      flash.now[:danger]= "投稿を編集できませんでした"
      render "posts/edit"
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "投稿を削除しました"
    redirect_to root_url
  end
  
  def img_delete
    @post = Post.find(params[:post_id])
    @post.remove_image!
    @post.save
    flash[:success] = "画像を削除しました"
    redirect_to @post
  end
    
  
  private
  
  def post_params
    params.require(:post).permit(:content,:image)
  end
   
  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    unless @post
     redirect_to root_url
    end
  end
  
end
