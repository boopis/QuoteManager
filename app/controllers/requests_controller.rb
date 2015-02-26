class RequestsController < ApplicationController
  before_filter :authenticate_user!, except: [:create]
  before_action :set_request, only: [:show, :destroy]

  skip_before_filter :verify_authenticity_token
  before_filter  :add_origin_header

  # GET /requests
  # GET /requests.json
  def index
    @q = current_account.requests.search(params[:q])
    @requests = @q.result.page(params[:page]).per(25)
    @header = current_account.forms.find(params[:q][:form_id_eq]) if params[:q].present? && params[:q][:form_id_eq].present?
    @forms = current_account.forms.all
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

    req_params = store_file(req_params)
    back = request.referrer

    if req_params[:errors].empty?
      @request = Request.new(req_params[:params])
      @request.account_id = form.account_id
      @request.status = 'pending'

      name = req_params[:params][:fields].find{|k,v| v['type'] == 'name'}
      phone = req_params[:params][:fields].find{|k,v| v['type'] == 'phone'}
      email = req_params[:params][:fields].find{|k,v| v['type'] == 'email'}
      email = email.last['request'] if email.present?
      name = name.last['request'] if name.present?
      phone = phone.last['request'] if phone.present?

      if email.present?
        contact = Contact.find_by_email(email) || Contact.new
        contact.email = email if contact.email.blank?
        contact.name = name if contact.name.blank?
        contact.phone = phone if contact.phone.blank?
        contact.save
        @request.contact = contact
      end

      # Check and get errors list
      errors = form.map_destination_data(req_params[:params])

      respond_to do |format|
        if errors.messages.size == 0 && @request.save
          format.html { redirect_to back, notice: 'Request was successfully created' }
          format.json { render json: @request.to_json, status: :created }
        else
          format.html { redirect_to back, alert: 'You need to enter all required fields' }
          format.json { render json: errors, status: :unprocessable_entity }
        end
      end
    else 
      respond_to do |format|
        format.html { redirect_to back, alert: 'Invalid form fields' }
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
    @request = current_account.requests.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def request_params
    params.require(:request).permit(:form_id).tap do |whitelisted|
      whitelisted[:fields] = params[:request][:fields]
    end    
  end

  def store_file(params)
    errors = {}

    params['fields'].each do |k, v| 
      if v['type'] == 'file'
        unless v['request'].nil?
          isValidFile = ['png', 'jpg', 'jpeg', 'gif', 'zip'].any? do |word| 
            v['request'].content_type.include?(word)
          end

          if !isValidFile
            errors[:file_extensions] = 'Only allow to add [jpg, png, gif, zip] file'
          end 

          if (v['request'].tempfile.size / 1000000 > 2) 
            errors[:file_size] = 'The file size exceeds the limit allowed and cannot be saved'
          else 
            uploader = FileUploader.new 
            uploader.cache!(v['request'])
            v['request'] = uploader.url
          end
        end
      end
    end
    { :params => params, :errors => errors }
  end
end
