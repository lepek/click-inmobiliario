class IndexController < ActionController::Base
  layout 'front_end'
  
  def index    
    @properties_json = Property.all.to_gmaps4rails   
  end
  
end
