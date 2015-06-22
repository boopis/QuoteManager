class PaymentsController < ApplicationController
  before_action :set_payments, only: [:new, :create, :edit, :update]
  before_filter :authenticate_user!

  def new
  end

  def create
    begin
      plan = @plans.find(params[:plan_id])
      @account.plan = plan
      customer = Stripe::Customer.create(email: current_user.email, plan: plan.id, card: params[:stripe_card_token])
      @account.stripe_customer_token = customer.id
      @account.stripe_subscription_token = customer.subscriptions.data[0].id
      @user.role = 'admin'
      @account.save && @user.save
      redirect_to root_url, notice: "You're ready to begin your free trial!"
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Plan is invalid"
      render :new
    rescue Stripe::StripeError => e
      flash[:error] = "#{e}"
      render :new
    rescue StandardError => e
      flash[:error] = "#{e}"
      render :new
    end
  end

  def edit
  end

  def update
    begin
      plan = @plans.find(params[:plan_id])
      customer = Stripe::Customer.retrieve(@account.stripe_customer_token)
      subscription = customer.subscriptions.retrieve(@account.stripe_subscription_token)
      subscription.plan = plan.id
      subscription.save
      @account.update(plan: plan)
      redirect_to root_url, notice: 'Subscription was successfully updated.'
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Plan is invalid"
      render :edit
    rescue Stripe::StripeError => e
      flash[:error] = "#{e}"
      render :edit
    rescue StandardError => e
      flash[:error] = "#{e}"
      render :edit
    end
  end

private
  def set_payments
    @account = current_account
    @plans = Plan.where.not(name: 'Free')
    @user = @account.users.find(current_user)
  end

  def payment_params
    params.permit(
      :plan_id,
      :stripe_card_token
    )
  end

end
