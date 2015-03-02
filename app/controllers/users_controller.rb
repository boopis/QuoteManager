class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    @user = current_account.users.find(params[:id])
    @user.avatar = Image.new if @user.avatar.nil?
  end
end
