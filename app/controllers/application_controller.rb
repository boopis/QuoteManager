class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  before_filter :load_schema

  def add_origin_header
    # For testing on your local machine on a normal browser, change this to your machine's IP
    # headers['Access-Control-Allow-Origin'] = 'http://localhost:8888';
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Methods"] = %w{GET POST PUT}.join(",")
    headers["Access-Control-Allow-Headers"] = %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(",")

    head(:ok) if request.request_method == "OPTIONS"
  end

private

  def load_schema
    Apartment::Database.switch('public')
    return unless request.subdomain.present?

    if current_account 
      Apartment::Database.switch(current_account.subdomain)
    else
      redirect_to root_url(subdomain: false)
    end
  end

  def current_account
    @current_account ||= Account.find_by(subdomain: request.subdomain)
  end
  helper_method :current_account

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
