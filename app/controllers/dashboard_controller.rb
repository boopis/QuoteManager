class DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :block_freeloaders!

  def index
    resource_usage
    request_quote_stat
  end

private
  def resource_usage
    users, forms, requests, storage = current_account.plan.limitation

    # Resource usage data
    @storage_used = current_account.storage_used
    @forms_used = current_account.forms_used
    @requests_used = current_account.requests_used

    @percent_storage_used = @storage_used / storage
    @percent_forms_used = @forms_used / forms
    @percent_requests_used = @requests_used / requests
  end

  def request_quote_stat
    @stat = Quote.count_status(current_account)
  end
end
