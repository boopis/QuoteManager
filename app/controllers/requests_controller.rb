class RequestsController < ApplicationController

  include Notable

  before_filter :authenticate_user!, except: [:create]
  before_filter :block_freeloaders!, except: [:create]
  before_action :set_request, only: [:show, :destroy]

  skip_before_filter :verify_authenticity_token
  before_filter  :add_origin_header
  load_and_authorize_resource param_method: :request_params

  # GET /requests
  # GET /requests.json
  def index
    @q = current_account.requests.includes(:note).search(params[:q])
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
    req_params = store_file(req_params, form.account.id)
    req_fields = req_params[:params][:fields]

    if req_params[:errors].empty?
      @request = Request.new(req_params[:params].merge({:account_id => form.account_id, :status => 'new' }))

      Contact.update_or_create_form_submitted(req_fields, @request, form.account_id)
     
      # Check and get errors list
      map_data = form.map_destination_data(req_fields, @request)
      if map_data[:errors].messages.size === 0 
        @request.assign_attributes(:fields => map_data[:request].fields.dup)
      end

      respond_to do |format|
        if map_data[:errors].messages.size == 0 && @request.save
          format.html { redirect_to request.referrer, notice: 'Request was successfully created' }
          format.json { render json: { request: @request, message: 'Thank you for using our services!' }.to_json, status: :created }

          send_thank_you_message_to_customer(form, @request.contact)
          send_mail_to_form_creator(
            form,  
            req_fields.find{|k,v| v['type'] == 'email'}.last['request']
          )
          
        else
          format.html { redirect_to request.referrer, alert: 'You need to enter all required fields' }
          format.json { render json: map_data[:errors], status: :unprocessable_entity }
        end
      end
    else 
      respond_to do |format|
        format.html { redirect_to request.referrer, alert: "Invalid form fields: #{req_params[:errors]}" }
        format.json { render json: req_params[:errors], status: :unprocessable_entity }
      end
    end
  end

  # POST /quotes/:id/note
  def update_note
    @request = Request.find(params[:request_id])
    update_notable(@request, params.require(:request).permit(:note_attributes => [:title, :content]))
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

  # GET /download/field_id
  def download
    @request = Request.find(params[:request_id])
    if @request
      send_file Rails.root.to_s + @request.fields[params[:field_id]]['request'], :x_sendfile=>true
    else 
      respond_to do |format|
        format.html { redirect_to requests_url, alert: 'Resource not found' }
        format.json { head :no_content }
      end
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

  def send_thank_you_message_to_customer(form, contact)
    Thread.new do
      FormMailer.thank_customer(contact, form).deliver
    end
  end

  def send_mail_to_form_creator(form, submitted_user)
    Thread.new do
      form.emails.each do |e|
        FormMailer.alert_to_form_creators(e['email'], submitted_user, form).deliver
      end
    end
  end

  def store_file(params, account_id)
    errors, files = {}, []

    params['fields'].each do |k, v| 
      if v['type'] == 'file'
        unless v['request'].nil?
          isError = false
          isValidFile = ['png', 'jpg', 'jpeg', 'gif', 'zip'].any? do |word| 
            v['request'].content_type.include?(word)
          end

          if !isValidFile
            errors[:file_extensions] = 'Only allow to add [jpg, png, gif, zip] file'
            isError = true
          end 

          file_size = v['request'].tempfile.size / 1000000
          account_used = current_account.storage_usage.to_f/1000000
          account_limit = current_account.plan.storage

          if (file_size > 2) || (file_size + account_used > account_limit) 
            errors[:file_size] = 'The file size exceeds the limit allowed and cannot be saved'
            isError = true
          end

          unless isError
            name = v['request'].original_filename.gsub('.', "-#{DateTime.now.strftime('%s')}.")
            url = "/uploads/files/#{account_id}/#{Date.today.strftime("%d-%m")}"
            dir = "#{Rails.root}" + url
            FileUtils.mkdir_p(dir) unless File.directory?(dir)
            File.open(File.join(dir, name), "wb") { |f| f.write(v['request'].read) }
            v['request'] = File.join(url, name)
          end
        end
      end
    end
    { :params => params, :errors => errors }
  end
end
