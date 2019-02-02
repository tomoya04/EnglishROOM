class ToppagesController < ApplicationController
  def index
    if logged_in?
      @posts = current_user.feed_posts.order('created_at DESC').page(params[:page])
    end
  end
end
