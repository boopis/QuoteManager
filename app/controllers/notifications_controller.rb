class NotificationsController < ApplicationController
  before_filter :authenticate_user!

  # GET /notifications
  def index
    @notifications = mailbox.inbox.page(params[:page]).per(25)

    # Mark all notification is read
    unread_notifications.each do |un|
      un.mark_as_read(current_user)
    end
  end

  # GET /notifications/:id
  def show
    @notification = mailbox.inbox.find(params[:id])

    # Mark this notification is read
    @notification.mark_as_read(current_user) unless @notification.nil? && @notification.is_unread?(current_user)
  end
end
