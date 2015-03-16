module Notable
  extend ActiveSupport::Concern

  def update_note
    respond_to do |format|
      if @quote.update(quote_params)
        format.html { redirect_to :back, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @quote }
      else
        format.html { redirect_to :back, alert: 'Note was updated failed.' }
      end
    end
  end
end

