class FormsController < ApplicationController
  before_action :set_form, only: [:show, :edit, :update, :destroy], except: [:formjs]
  before_filter :authenticate_user!, except: [:show, :formjs]
  
  after_filter  :add_origin_header

  # GET /forms
  # GET /forms.json
  def index
    @forms = Form.page(params[:page]).per(25)
  end

  # GET /forms/1
  # GET /forms/1.json
  def show
    @request = Request.new
  end

  # GET /forms/new
  def new
    @form = Form.new
    @fb = Form.new
  end

  # GET /forms/1/edit
  def edit
    @fb = Form.find(params[:id])
  end

  # POST /forms
  # POST /forms.json
  def create
    @form = Form.new(form_params)
    @fb = Form.new

    respond_to do |format|
      if @form.save
        format.html { redirect_to @form, notice: 'Form was successfully created.' }
        format.json { render :show, status: :created, location: @form }
      else
        format.html { render :new }
        format.json { render json: @form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /forms/1
  # PATCH/PUT /forms/1.json
  def update
    respond_to do |format|
      if @form.update(form_params)
        format.html { redirect_to @form, notice: 'Form was successfully updated.' }
        format.json { render :show, status: :ok, location: @form }
      else
        format.html { render :edit }
        format.json { render json: @form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forms/1
  # DELETE /forms/1.json
  def destroy
    @form.destroy
    respond_to do |format|
      format.html { redirect_to forms_url }
      format.json { head :no_content }
    end
  end

  # GET /forms/formjs
  def formjs
    render :partial => 'forms/formjs.js'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form
      @form = Form.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def form_params
      p = params.require(:form).permit(:name, fields: [:label, :type, :validate, :css, options: [:name]])
      p[:fields] = params[:form][:fields]
      p
    end
end
