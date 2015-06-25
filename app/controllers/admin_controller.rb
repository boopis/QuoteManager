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
end
