module Admin

  class IndexController < Admin::ApplicationController
    def index
      #ability = self.current_ability
      #@organizations = Organization.accessible_by(ability).all
      #@roles = Role.accessible_by(ability).all
      #@users = User.accessible_by(ability)
      
      @currencies = Currency.order("name").all
      @locations = Location.order("name").all
      @operations = Operation.order("name").all
      @properties = Property.all
      @real_estates = RealEstate.order("name").all
      @types = Type.order("name").all
      @users = User.order("last_name").all
    end
  end
end
