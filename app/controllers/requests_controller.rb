class RequestsController < ApplicationController
  before_filter :authenticate_user!, except: [:create]
  before_action :set_request, only: [:show, :destroy]
  
  skip_before_filter :verify_authenticity_token
  after_filter  :add_origin_header

  # GET /requests
  # GET /requests.json
  def index
    @q = Request.search(params[:q])
    @requests = @q.result.page(params[:page]).per(25)
    @header = Form.find(params[:q][:form_id_eq]) if params[:q].present? && params[:q][:form_id_eq].present?
    @forms = Form.all
    if params[:q].present? && params[:q][:key].present?
      @requests = @q.result.find_json(params[:q][:key],params[:q][:term])
    end
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
  end

  # POST /requests
  # POST /requests.json
  def create
    req_params = request_params
    form = Form.find(req_params[:form_id].to_i)
    @request = Request.new(req_params)
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

    # Check and get errors list
    errors = form.map_destination_data(req_params)

    respond_to do |format|
      if errors.messages.size == 0 && @request.save
        format.html { redirect_to back, notice: 'Request was successfully created' }
        format.json { render json: @request.to_json, status: :created }
      else
        format.html { redirect_to back, notice: 'Please enter required fields' }
        format.json { render json: errors, status: :unprocessable_entity }
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
