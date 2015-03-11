class DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :block_freeloaders!

  def index
    storage = current_account.plan.storage
    usage = current_account.storage_usage.to_f/1000000
    @percent_used = (usage / storage)
  end
end
