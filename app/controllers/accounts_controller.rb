class AccountsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:new, :create, :login]

  def new
    if params[:plan_id].nil?
      redirect_to root_url(subdomain: false, anchor: "pricing")
    else
      plan = Plan.find(params[:plan_id])
      @account = plan.accounts.build
      @account.users.build
    end
  end

  def create
    @account = Account.new(account_params)
    respond_to do |format|
      if @account.save
        format.html { redirect_to new_user_session_url, notice: 'Account was successfully created. Please sign in.' }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def login
    @account = current_account
    if @account
      redirect_to new_user_session_url
   else
      redirect_to new_account_path, flash: { 
        :alert => 'Account is invalid. Create an account.' 
      }
   end
  end

  def edit
    render :edit, locals: { current_account: current_account, errors: [] }
  end

  def update
    respond_to do |format|
      if current_account.update(edit_params)
        format.html { 
          redirect_to(
            edit_account_path(current_account), 
            notice: 'User profile was successfully updated.' 
          )
        }
        format.json { render :edit, status: :ok, location: current_account }
      else
        format.html { render :edit, alert: 'User profile was not successfully updated.' }
        format.json { render json: current_account.errors, status: :unprocessable_entity }
      end
    end
  end

private
  def account_params
    params.require(:account).permit(
      :company_name,
      :plan_id,
      users_attributes: [
        :firstname, 
        :lastname, 
        :email, 
        :password, 
        :password_confirmation
      ]
    )
  end

  def edit_params
    params.require(:account).permit(
      :company_name,
      :phone_number,
      :address,
      :about,
      :company_logo_attributes => [:image]
    )
  end
end
