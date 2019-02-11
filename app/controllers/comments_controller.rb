class CommentsController < ApplicationController
  before_action :require_user_logged_in
  
  def create
   @post = Post.find(params[:post_id])
   @comment = @post.comments.build(comment_params)
   @comment.user_id = current_user.id
   
   
    if @comment.save
      flash[:success]= "Make a comment on post" 
      redirect_back(fallback_location: root_path)
    else
      flash.now[:danger]= "Failed to post a comment" 
      redirect_back(fallback_location: root_path)
    end
  end
  
  def destroy
   
    comment = Comment.find(params[:id])
    comment.destroy
    flash[:success]= "The comment has been deleted" 
    redirect_back(fallback_location: root_path)
  end
    
  private
  
  def comment_params
    params.require(:comment).permit(:content)
  end
end
