module Admin

  class IndexController < Admin::ApplicationController
    
    def index
      authorize! :access, :admin_module
      
      @currencies = Currency.accessible_by(current_ability).order("name").all
      @locations = Location.accessible_by(current_ability).order("name").all
      @operations = Operation.accessible_by(current_ability).order("name").all
      @properties = Property.accessible_by(current_ability).all
      @real_estates = RealEstate.accessible_by(current_ability).order("name").all
      @types = Type.accessible_by(current_ability).order("name").all
      @users = User.accessible_by(current_ability).order("last_name").all
      @poi_types = PoiType.accessible_by(current_ability).order("name").all
    end
  end
end
