class ContactsController < ApplicationController
  include Notable

  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  before_filter :block_freeloaders!
  #load_and_authorize_resource param_method: :contact_params
  
  # GET /contacts
  # GET /contacts.json
  def index
    @q = current_account.contacts.includes(:note).search(params[:q])
    @contacts = @q.result.page(params[:page]).per(25)
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @quotes = Quote.from_contact(@contact.id)
    @requests = @contact.requests

    @no_requests = @requests.pluck(:id).count
    @no_quotes = @quotes.pluck(:id).count
  end

  # GET /contacts/new
  def new
    @contact = current_account.contacts.new
    @contact.avatar ||= Image.new
    @contact.note ||= Note.new
    @contact.address ||= Address.new
  end

  # GET /contacts/1/edit
  def edit
    @contact.avatar ||= Image.new
    @contact.address ||= Address.new
    @contact.note ||= Note.new
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = current_account.contacts.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /contacts/:id/send-email
  def send_email
    @templates = current_account.templates.where(using_type: 'Contact')
  end

  # POST /contacts/:id/send-email
  def send_email_to_contact
    identities = @current_user.identities.where(provider: 'google_oauth2')
    contact = Contact.find(params[:contact_id])

    respond_to do |format|
      if identities.count > 0 && contact
        # Compose new email
        if params[:send_method] == 'Compose New Email'
          template = params[:content] 
        else
          template = Template.find(params[:template_id]).try(:content)
        end
      
        unless identities[0].refresh_token.nil?
          gmail_api = GmailAPI.new(identities[0].fresh_token)
          mail = ContactMailer.send_email(contact, template, identities[0].social_name, params[:subject])
          gmail_api.send_message(mail)

          format.html { redirect_to :back, notice: 'Your email is being sent to this contact.' }
          format.json { render json: params[:email], status: :ok }
        else
          format.html { redirect_to :back, alert: 'Unable to get Google refresh token. Please contact to supporter to fix this error.' }
          format.json { render json: params[:email], status: 400 }
        end
      else
        format.html { redirect_to :back, alert: 'You must connect your account with Gmail to send your email.' }
        format.json { render json: params[:email], status: 400 }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /quotes/:id/note
  def update_note
    @contact = Contact.find(params[:contact_id])
    update_notable(@contact, contact_params)
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.json { head :no_content }
    end
  end

  # POST /contacts/import
  def import
    unless params[:file].nil?
      errors = Contact.import(params[:file], current_account.id)
    else
      errors = 'Please insert your import file!'
    end
    respond_to do |format|
      if errors.empty?
        format.html { redirect_to contacts_path, notice: 'Contact was successfully imported.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { redirect_to contacts_path, flash: { alert: errors } }
        format.json { render json: errors, status: :unprocessable_entity }
      end
    end

  end

  private
    
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = current_account.contacts.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(
        :name, 
        :phone, 
        :email, 
        :title,
        :description,
        :social_media => [
          :facebook => [:user, :url], 
          :twitter => [:user, :url], 
          :linkedin => [:user, :url]
        ],
        :address_attributes => [:address_line_1, :address_line_2, :city, :postal_code],
        :note_attributes => [:title, :content],
        :avatar_attributes => [:image]
      )
    end
end
