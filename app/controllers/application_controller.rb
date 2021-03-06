class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'front_end'
  
  before_filter :set_current_user
  
  private
  
  def set_current_user
    User.current_user = current_user
  end
end
