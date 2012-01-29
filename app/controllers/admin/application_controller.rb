require 'datatables/controller_mixin'

module Admin

  class ApplicationController < ::ApplicationController
    include Datatables::ControllerMixin
  end
  
end
