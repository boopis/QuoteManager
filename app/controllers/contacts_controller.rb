class ContactsController < ApplicationController
  include Notable

  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  before_filter :block_freeloaders!
  
  # GET /contacts
  # GET /contacts.json
  def index
    @q = current_account.contacts.includes(:note).search(params[:q])
    @contacts = @q.result.page(params[:page]).per(25)
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
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
