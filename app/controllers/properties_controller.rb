require 'datatables/controller_mixin'
class PropertiesController < ApplicationController
  include Datatables::ControllerMixin
  impressionist :unique => [:impressionable_type, :impressionable_id, :session_hash], :actions => [ :show ]
  
  before_filter :authenticate_user!, :only => [:favorite, :favorites_list]

  # GET /properties/1
  # GET /properties/1.json
  def show
    @property = Property.find(params[:id])
    @is_favorite = (user_signed_in? and current_user.properties.exists?(@property))
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @property }
    end
  end
  
  def favorite
    @property = Property.find(params[:id])
    is_favorite = current_user.properties.exists?(@property)
    if is_favorite
      flash[:success] = "El inmueble ubicado en #{@property.address.upcase} fue eliminado de sus favoritos." 
      current_user.properties.delete(@property)
    else
      flash[:success] = "El inmueble ubicado en #{@property.address.upcase} fue agregado a sus favoritos."
      current_user.properties << @property
    end
    current_user.reload
    
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "No se encontro la propiedad solicitada."
  ensure
    redirect_to :back      
  end
  
  def favorites_list
    @properties = current_user.properties
  end
  
end
