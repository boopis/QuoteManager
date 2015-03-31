class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  def add_origin_header
    # For testing on your local machine on a normal browser, change this to your machine's IP
    # headers['Access-Control-Allow-Origin'] = 'http://localhost:8888';
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Methods"] = %w{GET POST PUT}.join(",")
    headers["Access-Control-Allow-Headers"] = %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(",")

    head(:ok) if request.request_method == "OPTIONS"
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private

  def system_account
    User.find_by_email('system@qm.com')
  end

  def mailbox
    if signed_in?
      current_user.mailbox
    else
      nil
    end
  end

  def unread_notifications
    if signed_in?
      mailbox.inbox.unread(current_user)
    else
      nil
    end
  end

  def current_account
    if signed_in?
      @current_account ||= current_user.account
    else
      @current_account = nil
    end
  end

  helper_method :current_account, :mailbox, :unread_notifications, :system_account

  def block_freeloaders!
    if current_account.plan.nil?
      flash[:notice] = 'You must fill in payment details before continuing!'

      redirect_to new_payment_path

      return false
    end
  end

end
