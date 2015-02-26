class WelcomeController < ApplicationController
  def index
    @account = Account.new
    @account.users.build
  end
end
