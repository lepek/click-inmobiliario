require 'datatables/controller_mixin'

module Admin

  class ApplicationController < ::ApplicationController
    include Datatables::ControllerMixin
    
    before_filter :authenticate_user!, :unless => :devise_controller? 
    
  end
  
end
