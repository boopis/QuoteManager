class WelcomeController < ApplicationController
  caches_page :index

  def index
    @account = Account.find_by_company_name('Boopis Media')
    if @account.present?
      @account.users.build
      @form = @account.forms.find_by_name('QM Contact Form')
      @request = @account.requests.new
    end
  end
end
