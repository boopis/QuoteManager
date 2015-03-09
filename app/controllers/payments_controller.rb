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
      begin
        plan = @plans.find(params[:plan_id])
        @account.plan = plan
        customer = Stripe::Customer.create(email: current_user.email, plan: plan.id, card: params[:stripe_card_token])
        @account.stripe_customer_token = customer.id
      rescue ActiveRecord::RecordNotFound
        flash[:error] = "Plan is invalid"
        render :new
        return
      rescue StandardError => e
        flash[:error] = "#{e}"
        render :new
      end

      if @account.save
        format.html { redirect_to root_url, notice: "You're ready to begin your free trial!" }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
      format.html { render :new, notice: "Plan is invalid" }
      format.json { render json: "You must choose a valid plan", status: :unprocessable_entity }
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
