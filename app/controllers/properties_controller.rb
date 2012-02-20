class PropertiesController < ApplicationController

  before_filter :authenticate_user!, :only => [:contact]

  impressionist :unique => [:impressionable_type, :impressionable_id, :session_hash], :actions => [ :show ]

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
  
end
