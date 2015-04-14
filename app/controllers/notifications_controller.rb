class NotificationsController < ApplicationController
  before_filter :authenticate_user!, :get_mailbox
  before_filter :get_unread, only: [:index, :unread]

  # GET /notifications
  def index
    @notifications = @mailbox.notifications.page(params[:page]).per(25)

    # Mark all notification is read
    @unread.each do |un|
      un.mark_as_read(current_user)
    end
  end

  # GET /notifications/:id
  def show
    @notification = @mailbox.notifications.find(params[:id])

    # Mark this notification is read
    @notification.mark_as_read(current_user) unless @notification.nil? && @notification.is_unread?(current_user)
  end

  # GET /notifications/unread
  def unread
    render :json => { notifications: @unread.first(5), status: 200 } 
  end

  def get_mailbox
    @mailbox = current_user.mailbox
  end
  
  def get_unread
    @unread = @mailbox.notifications.unread
  end
end
