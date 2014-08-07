class RequestsController < ApplicationController
  before_filter :authenticate_user!, except: [:create]
  before_action :set_request, only: [:show, :destroy]

  # GET /requests
  # GET /requests.json
  def index
    @all_requests = Request.all
    @requests = Request.where(form_id: params[:form_id])
    @header = Form.find(params[:form_id]) if params[:form_id].present?
    @forms = Form.all
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
  end

  # POST /requests
  # POST /requests.json
  def create
    @request = Request.new(request_params)
    email = params[:request][:fields].find{|k,v| v['type'] == 'email'}
    name = params[:request][:fields].find{|k,v| v['type'] == 'name'}
    phone = params[:request][:fields].find{|k,v| v['type'] == 'phone'}
    email = email.last['request'] if email.present?
    name = name.last['request'] if name.present?
    phone = phone.last['request'] if phone.present?
    back = request.referrer

    if email.present?
      contact = Contact.find_by_email(email) || Contact.new
      contact.email = email if contact.email.blank?
      contact.name = name if contact.name.blank?
      contact.phone = phone if contact.phone.blank?
      contact.save
      @request.contact = contact
    end

    respond_to do |format|
      if @request.save
        format.html { redirect_to back, notice: 'Request was successfully created' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params.require(:request).permit(:form_id).tap do |whitelisted|
        whitelisted[:fields] = params[:request][:fields]
      end    
    end
end
