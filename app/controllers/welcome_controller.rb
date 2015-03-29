class WelcomeController < ApplicationController
  def index
    @account = Account.find_by_company_name('System')
    @account.users.build
    @form = @account.forms.find_by_name('Contact Form')
    @request = @account.requests.new
  end
end
