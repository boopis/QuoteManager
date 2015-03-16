module Notable
  extend ActiveSupport::Concern

  def update_notable(notable, note)
    respond_to do |format|
      if notable.update(note)
        format.html { redirect_to :back, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @quote }
      else
        format.html { redirect_to :back, alert: 'Quote was failed updated.' }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end
end
