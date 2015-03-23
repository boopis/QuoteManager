class AccountsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:new, :create, :login]
  load_and_authorize_resource param_method: :account_params

  def new
    @account = Account.new
    @account.users.build
  end

  def create
    @account = Account.new(account_params)
    plan_id = params[:plan_id]
    respond_to do |format|
      if @account.save
        sign_in(@account.users[0])
        if params[:plan_id].present?
          format.html { redirect_to new_payment_url(plan_id: params[:plan_id]), notice: 'Please add payment details to begin trial.' }
        else
          format.html { redirect_to new_payment_url, notice: 'Account was successfully created. Please choose a plan.' }          
        end
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
    current_account.address ||= Address.new
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
      :about,
      address_attributes: [:address_line_1, :address_line_2, :city, :postal_code],
      :company_logo_attributes => [:image]
    )
  end
end
