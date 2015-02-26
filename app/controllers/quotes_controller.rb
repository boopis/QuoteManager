class QuotesController < ApplicationController
  before_filter :authenticate_user!, except: [:public]
  before_action :check_token, only: [:public]
  before_action :set_quote, only: [:show, :edit, :update, :destroy]
  before_action :parse_request, only: [:public]

  # GET /quotes
  # GET /quotes.json
  def index
    @quotes = current_account.quotes.page(params[:page]).per(25)
  end

  # GET /quotes/1
  # GET /quotes/1.json
  def show
  end

  # GET /quotes/new
  def new
    @quote = current_account.quotes.new
    @qb = current_account.quotes.new
    @request = current_account.requests.find(params[:request_id]) if params[:request_id]
  end

  # GET /quotes/1/edit
  def edit
    @qb = current_account.quotes.find(params[:id])
    @request = current_account.requests.find(@qb.request_id)
  end

  # POST /quotes
  # POST /quotes.json
  def create
    @quote = current_account.quotes.new(quote_params)

    respond_to do |format|
      if @quote.save
        format.html { redirect_to @quote, notice: 'Quote was successfully created.' }
        format.json { render :show, status: :created, location: @quote }
      else
        format.html { render :new }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotes/1
  # PATCH/PUT /quotes/1.json
  def update
    respond_to do |format|
      if @quote.update(quote_params)
        format.html { redirect_to @quote, notice: 'Quote was successfully updated.' }
        format.json { render :show, status: :ok, location: @quote }
      else
        format.html { render :edit }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotes/1
  # DELETE /quotes/1.json
  def destroy
    @quote.destroy
    respond_to do |format|
      format.html { redirect_to quotes_url }
      format.json { head :no_content }
    end
  end

  # GET /quotes/1?token=
  def public
    Quote.find(params[:id])
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_quote
    @quote = current_account.quotes.find(params[:id])
  end

  def parse_request
    @quote = Quote.find(params[:id])
    @company = @quote.account
    if @quote.options.present?
      @total = @quote.amount + @quote.options.map { |id, op| op['amount'].to_f }.inject(:+) 
    else
      @total = @quote.amount
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def quote_params
    params.require(:quote).permit(:amount, :token, :expires_at, :request_id, :description, options: [:description, :amount])
  end

  def token_validity
    token = Quote.find_by_token(params[:token])
  end

  def check_token
    unless user_signed_in?
      if token_validity.nil?
        redirect_to root_url, alert: "Not authorized"
      elsif token_validity.expires_at <= Time.now
        redirect_to root_url, alert: "Offer has expired"
      end
    end
  end
end
