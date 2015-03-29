class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :edit, :update, :destroy, :create_message]
  before_action :logged_user
  before_action :allowed_user, only: [:show, :update, :destroy]


  # GET /conversations
  # GET /conversations.json
  def index
    @conversations = current_user.conversations.order(:updated_at => :desc).distinct!
  end

  # GET /conversations/1
  # GET /conversations/1.json
  def show
    @recipients = @conversation.recipients.where(:user_id => current_user.id).includes(:message).order(:created_at => :asc)
    @message = Message.new
  end

  # GET /conversations/new
  def new
    @conversation = Conversation.new
    @message = Message.new
  end

  # GET /conversations/1/edit
  def edit
  end

  # POST /conversations
  # POST /conversations.json
  def create
    @conversation = Conversation.new(:subject => conversation_params[:subject])
    @message = Message.new(conversation_params[:message])

    if @conversation.invalid? | @message.invalid? | invalid_user_ids?(conversation_params[:user_ids])
      render :new
      return
    end

    @conversation.transaction do
      @message.save!
      @conversation.save!
      Recipient.create!(:message_id => @message.id, :user_id => current_user.id, :author_id => current_user.id, :conversation_id => @conversation.id)
      conversation_params[:user_ids].each do |user|
        if user.present?
          Recipient.create!(:message_id => @message.id, :user_id => user.to_i, :author_id => current_user.id, :conversation_id => @conversation.id)
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to @conversation, notice: 'Conversation was successfully created.' }
    end
  end

  # PATCH/PUT /conversations/1
  # PATCH/PUT /conversations/1.json
  def update
    @conversation.assign_attributes(:subject => conversation_params[:subject])
    if @conversation.invalid?
      render :edit
      return
    end

    @conversation.transaction do
      @conversation.save!
      conversation_params[:user_ids].each do |user|
        if user.present?
          # Adding new user to conversation
          # Without message
          Recipient.create!(:user_id => user.to_i, :conversation_id => @conversation.id, :author_id => current_user.id)
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to @conversation }
    end
  end

  def create_message
    message = Message.new(message_params)
    if message.invalid?
      redirect_to @conversation, notice: 'Message cant be blank'
      return
    end

    @conversation.transaction do
      message.save!
      @conversation.update_attribute(:updated_at, Time.now)
      @conversation.users.uniq.each do |user|
        Recipient.create!(:message_id => message.id, :user_id => user.id, :author_id => current_user.id, :conversation_id => @conversation.id)
      end
    end

    respond_to do |format|
      format.html { redirect_to @conversation }
    end
  end

  # DELETE /conversations/1
  # DELETE /conversations/1.json
  def destroy
    Recipient.where(:conversation_id => @conversation.id, :user_id => current_user.id).update_all(deleted: true)
    respond_to do |format|
      format.html { redirect_to conversations_url, notice: 'Conversation was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conversation
      @conversation = Conversation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conversation_params
      params.require(:conversation).permit(:subject, :message => [:title, :body], :user_ids => [])
    end

    def message_params
      params.require(:message).permit(:title, :body)
    end

    def allowed_user
      if !@conversation.user_ids.include?(current_user.id)
        redirect_to root_url, notice: 'You cant view this page'
      end
    end

    def invalid_user_ids?(user_ids)
      if user_ids.first.blank? && user_ids.size == 1
        @conversation.errors.add(:user_ids)
        return true
      else
        return false
      end
    end
end
