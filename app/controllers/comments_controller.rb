class CommentsController < ApplicationController
  def create
   @post = Post.find(params[:post_id])
   @comment = @post.comments.build(comment_params)
   @comment.user_id = current_user.id
   
   
    if @comment.save
      flash[:success]= "コメントしました" 
      redirect_back(fallback_location: root_path)
    else
      flash.now[:danger]= "コメントに失敗しました" 
      redirect_back(fallback_location: root_path)
    end
  end
  
  def destroy
   
    comment = Comment.find(params[:id])
    comment.destroy
    flash[:success]= "コメントを削除しました" 
    redirect_back(fallback_location: root_path)
  end
    
  private
  
  def comment_params
    params.require(:comment).permit(:content)
  end
end
