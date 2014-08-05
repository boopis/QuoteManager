class WelcomeController < ApplicationController
  def index
    @account = Account.new
    @account.build_owner
  end
end
