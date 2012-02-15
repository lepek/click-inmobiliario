class PropertiesController < ApplicationController

  impressionist :unique => [:impressionable_type, :impressionable_id, :session_hash], :actions => [ :show ]

  # GET /properties/1
  # GET /properties/1.json
  def show
    @property = Property.find(params[:id])
    abort(@property.impressionist_count.to_s)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @property }
    end
  end
  
end
