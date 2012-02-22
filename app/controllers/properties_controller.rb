require 'datatables/controller_mixin'
class PropertiesController < ApplicationController
  include Datatables::ControllerMixin
  impressionist :unique => [:impressionable_type, :impressionable_id, :session_hash], :actions => [ :show ]
  
  before_filter :authenticate_user!, :only => [:contact, :favorites_list]

  # GET /properties/1
  # GET /properties/1.json
  def show
    @property = Property.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @property }
    end
  end
  

  def contact
    property = Property.find(params[:id])
    PropertyMailer.contact_email(property, current_user, params[:comments]).deliver
    redirect_to property, notice: 'E-mail enviado a la inmobiliaria'
  end

  def favorite
    unless user_signed_in?
      flash[:alert] = I18n.t('devise.failure.unauthenticated')
      render :js => "window.location = '#{new_user_session_path}'"
      return
    end
    @property = Property.find(params[:id])
    if @property.is_favorite?
      flash_message = "El inmueble ubicado en #{@property.address.upcase} fue eliminado de sus favoritos."
      current_user.properties.delete(@property)
    else
      flash_message = "El inmueble ubicado en #{@property.address.upcase} fue agregado a sus favoritos."
      current_user.properties << @property
    end
    current_user.reload
    
    unless request.xhr?
      flash[:success] = flash_message
      redirect_to :back and return
    end
    respond_to do |format|
      if params[:referer] and params[:referer] == "show"
        format.js { render :partial => 'favorite', :locals => { :is_favorite => @property.is_favorite?, :flash_message => flash_message } }        
      else
        infowindow_content = render_to_string( :partial => 'index/infowindow', :locals => { :property => @property } )
        format.js { render :partial => 'infowindow', :locals => { :property_id => @property.id, :infowindow_content => infowindow_content } }
      end
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "No se encontro la propiedad solicitada."
    redirect_to :back
  end
  
  def favorites_list
    @properties = current_user.properties
  end
  
end
