class UsersController < ApplicationController
  before_filter :authenticate_user!, :set_user, only: [:show, :update, :destroy]
  before_filter :block_freeloaders!

  # GET /users
  # GET /users.json
  def index
    @users = current_account.users.all
  end

  def show
    @user = current_account.users.find(params[:id])
    @user.avatar ||= Image.new
    @user.account.company_logo ||= Image.new
  end

  # GET /users/new
  def new
    @user = current_account.users.new
  end

  # POST /users
  # POST /users.json
  def create_user
    @user = current_account.users.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @form }
      else
        format.html { render :show, alert: 'User profile was not successfully updated.' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

private

  def set_user
    @user = current_account.users.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :firstname,
      :lastname,
      :email,
      :password,
      :password_confirmation,
      :bio,
      :address,
      :phone_number,
      avatar_attributes: [:image],
      account_attributes: [
        :company_name,
        :company_logo_attributes => [:image]
      ]
    )
  end
end
