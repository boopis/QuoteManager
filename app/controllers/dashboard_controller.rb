class DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :block_freeloaders!

  def index
    users, forms, requests, storage = current_account.plan.limitation
    @storage_used = current_account.storage_used
    @forms_used = current_account.forms_used
    @requests_used = current_account.requests_used

    @percent_storage_used = @storage_used / storage
    @percent_forms_used = @forms_used / forms
    @percent_requests_used = @requests_used / requests
  end
end
