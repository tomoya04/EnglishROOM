class FavoritesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)
    flash[:success] = "いいねしました。"
    redirect_back(fallback_location: root_path)
    
  end

  def destroy
    @post = Post.find(params[:post_id])
    current_user.unlike(@post)
    flash[:success] = "いいねを解除しました。"
    redirect_back(fallback_location: root_path)
  end
end
