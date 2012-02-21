require 'datatables/controller_mixin'

module Admin

  class ApplicationController < ::ApplicationController
    before_filter :authenticate_user!, :unless => :devise_controller?
    layout 'application'
    include Datatables::ControllerMixin
  end
  
end
