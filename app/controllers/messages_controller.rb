class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def index
    @recipients = Recipient.includes(:message).where(:user_id => current_user)
  end

  def create
    @message = Message.new(message_params)
    respond_to do |format|
      if @message.save
        Recipient.create!(:user_id => current_user.id, :inbox => false, :message_id => @message.id)
        format.html { redirect_to new_message_path, notice: 'Message sent' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @message = Message.find(params[:id])
    Recipient.where(:message_id => @message.id, :user_id => current_user.id).update_all(:deleted => true)
  end

  def show
    @message = Message.find(params[:id])
    recipient = Recipient.where(:message_id => @message.id, :user_id => current_user.id, :read => false).first
    recipient.update_attribute(:read, true) if recipient
  end

  def dialog
  end

  private

    def message_params
      params.require(:message).permit(:title, :body, :user_ids => [])
    end
end
