class IndexController < ActionController::Base
  layout 'front_end'
  
  def index    
    @properties_json = Property.all.to_gmaps4rails   
  end

  def search
    properties = Property.search(
        :location_id => params[:location_id].to_i,
        :type_id => params[:type_id].to_i,
        :operation_id => params[:operation_id].to_i,
        :currency_id => params[:currency_id].to_i,
        :price => params[:price].to_i
    )
    respond_to do |format|
        format.json { render json: properties.to_gmaps4rails }
    end
  end
  
end
