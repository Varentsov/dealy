class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show, :destroy]

  # GET /notifications
  # GET /notifications.json
  def index
    @notifications = Notification.where(employee_id: current_user.employee_ids).order(created_at: :desc)
  end

  # GET /notifications/1
  # GET /notifications/1.json
  def show
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: 'Уведомление удалено' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_params
      params.require(:notification).permit(:index, :show, :destroy)
    end
end
