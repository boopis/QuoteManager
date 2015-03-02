class UsersController < ApplicationController
  before_filter :authenticate_user!, :set_form
  
  def show
    @user = current_account.users.find(params[:id])
    @user.avatar = Image.new if @user.avatar.nil?
  end

  def update
    respond_to do |format|
      if @user.update(user_param)
        format.html { redirect_to @user, notice: 'User profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @form }
      else
        format.html { render :show, alert: 'User profile was not successfully updated.' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_form
    @user = User.find(params[:id])
  end

  def user_param
    params.require(:user).permit(
      :id,
      :firstname,
      :lastname,
      :bio,
      :address,
      :phone_number,
      avatar_attributes: [:image]
    )
  end
end
