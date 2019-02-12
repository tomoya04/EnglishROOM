class MessagesController < ApplicationController
  before_action :require_user_logged_in,only: [:index]
  
  def index
    @user = User.find(params[:user_id])
    send_ids = current_user.messages.where(receive_user_id: @user.id).pluck(:id)
    receive_ids = @user.messages.where(receive_user_id: current_user.id).pluck(:id)
    @messages = Message.where(id: send_ids + receive_ids).order(created_at: :ASC)
    @message = Message.new
  end

  def create
    @user = User.find(params[:user_id])
    @message = current_user.messages.build(message_params)
    @message.receive_user_id = @user.id
    
    if @message.save
      flash[:success] = "Sent DM message"
      redirect_back(fallback_location: root_path)
    else
      flash.now[:danger] = "Failed to send DM message"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    flash[:success] = "Message has been deleted"
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  
  def message_params
    params.require(:message).permit(:content)
  end
end
