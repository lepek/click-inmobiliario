class PropertiesController < ApplicationController
  
  # GET /properties/1
  # GET /properties/1.json
  def show
    @property = Property.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @property }
    end
  end
  
end
