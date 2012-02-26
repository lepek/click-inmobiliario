class IndexController < ApplicationController
  
  def index    
    @properties_json = Property.all.to_gmaps4rails
  end

  def search
    properties = Property.search(
        :location_id => params[:location_id].to_i,
        :type_id => params[:type_id].to_i,
        :operation_id => params[:operation_id].to_i,
        :currency => params[:currency_code],
        :price => Money.from_numeric(params[:price].to_i).cents
    )
    Search.log(params, current_user || nil)

    respond_to do |format|
        format.json { render json: properties.to_gmaps4rails }
    end
  end
  
end
