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
      flash[:success]= "Posted successfully"
      redirect_to root_url
    else
      @posts = current_user.feed_posts.order('created_at DESC').page(params[:page])
      flash.now[:danger]="Failed to post"
      render "toppages/index"
    end
  end 

  def edit
    @post = current_user.posts.find_by(id: params[:id])
  end

  def update
   @post = current_user.posts.find_by(id: params[:id])
    
   
    
    if  @post.update(post_params)
      flash[:success] = "Edit the post"
      redirect_to @post
    else
      flash.now[:danger]= "Failed to edit the post"
      render "posts/edit"
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "Post has been deleted"
    redirect_to root_url
  end
  
  def img_delete
    @post = Post.find(params[:post_id])
    @post.remove_image!
    @post.save
    flash[:success] = "Image has been deleted"
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
