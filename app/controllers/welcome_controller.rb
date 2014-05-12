class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!, only: :index

  def index
    @account = Account.new
    @account.build_owner
  end
end
