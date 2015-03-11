class QuotesController < ApplicationController
  before_filter :authenticate_user!, except: [:accept_quote, :public]
  before_filter :block_freeloaders!, except: [:accept_quote, :public]
  before_action :set_quote, only: [:show, :edit, :update, :destroy, :accept_quote]
  before_action :check_token, only: [:public]
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
    @quote.status = 'new'

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

  # POST /quotes/:id 
  # User accept a quote
  def accept_quote
    @quote.signature = params[:sig]
    @quote.status = 'complete'
    @quote.request.status = 'completed'
    if @quote.save
      redirect_to :back, :notice => "You have accepted this quote"
    else
      redirect_to :back, :notice => "Can't save your signature"
    end
  end

  # GET /quotes?token=
  def public
  end

  # POST /quotes/:id/send-quote
  def send_quote
    quote = Quote.find(params[:quote_id])
    errors = find_invalid_email(params[:email]['addresses'].split(','))

    respond_to do |format|
      if errors.nil? 
        send_quote_email(params[:email], quote)

        format.html { redirect_to :back, notice: 'Your email is being sent to customer.' }
        format.json { render json: params[:email], status: :ok }
      else 
        format.html { redirect_to :back, alert: 'Invalid email address.' }
        format.json { render json: params[:email], status: 400 }
      end
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_quote
    @quote = Quote.find(params[:id])
  end

  def find_invalid_email(emails)
    emails.detect do |e| 
      e.match(/\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/).nil?
    end
  end

  def send_quote_email(email, quote)
    Thread.new do
      email['addresses'].split(',').each do |address|
        QuoteMailer.send_quote(address, quote, email['content']).deliver
      end
    end
  end

  def parse_request
    @quote = Quote.find(params[:id])
    @company = @quote.account
    if @quote.options.present?
      @total = @quote.amount + @quote.options.map { |id, op| op['amount'].to_f }.inject(:+) 
    else
      @total = @quote.amount
    end

    # Get sender information
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
