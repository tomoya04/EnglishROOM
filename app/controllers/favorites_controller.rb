class FavoritesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)
    flash[:success] = "Liked the post"
    redirect_back(fallback_location: root_path)
    
  end

  def destroy
    @post = Post.find(params[:post_id])
    current_user.unlike(@post)
    flash[:success] = "Like has been deleted"
    redirect_back(fallback_location: root_path)
  end
end
