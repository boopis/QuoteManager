class AdminController < ApplicationController
  before_filter :authenticate_user!

  def index
    @accounts = Account.includes(
      :users, 
      :forms, 
      :requests, 
      :quotes, 
      :templates, 
      :plan
    ).order(:id).page(params[:page]).per(25)
  end

  def deactive
    account = Account.find(params[:account_id])
    active_account(account, false)

    respond_to do |format|
      format.html { redirect_to :back, notice: "Account #{account.company_name} is deactived." }
    end
  end


  def active
    account = Account.find(params[:account_id])
    active_account(account, true)

    respond_to do |format|
      format.html { redirect_to :back, notice: "Account #{account.company_name} is actived." }
    end
  end

  private
  # Active / deactive account
  def active_account(account, state)
    if account.present? 
      ActiveRecord::Base.transaction do
        account.users.each do |u|
          u.update_attributes(active: state)
        end
      end
    end
  end
end
