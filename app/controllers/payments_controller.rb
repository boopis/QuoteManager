class PaymentsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @account = current_account
    @plans = Plan.all
  end

  def create
    @account = current_account
    @plans = Plan.all
    respond_to do |format|
      if @plans.exists?(params[:plan_id])
        plan = @plans.find(params[:plan_id])
        customer = Stripe::Customer.create(email: @account.users[0].email, plan: plan.id, card: params[:stripe_card_token])
        @account.plan = plan
        @account.stripe_customer_token = customer.id
        @account.save
        format.html { redirect_to root_url, notice: "You're ready to begin your free trial!" }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

private
  def payment_params
    params.permit(
      :plan_id,
      :stripe_card_token
    )
  end
end
