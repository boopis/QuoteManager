class DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :block_freeloaders!

  def index
    resource_usage
    request_quote_stat
  end

private
  def resource_usage
    @users, @forms, @requests, @storage = current_account.plan.limitation
    # Resource usage data
    forms_used, requests_used, storage_used = current_account.resource_used

    @percent_resource_usage = [ 
      forms_used * 100.0 / @forms, 
      requests_used * 100.0 / @requests, 
      storage_used * 100.0 / @storage 
    ]
  end

  def request_quote_stat
    @stat = QuoteTransition.quote_stat(current_account.id)
                           .update(current_account.count_quote)
  end
end
