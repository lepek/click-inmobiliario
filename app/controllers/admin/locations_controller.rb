module Admin
  class LocationsController < Admin::ApplicationController
    # GET /locations
    # GET /locations.json
    def index
      @locations = Location.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @locations }
      end
    end

    # GET /locations/1
    # GET /locations/1.json
    def show
      @location = Location.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @location }
      end
    end

    # GET /locations/new
    # GET /locations/new.json
    def new
      @location = Location.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @location }
      end
    end

    # GET /locations/1/edit
    def edit
      @location = Location.find(params[:id])
    end

    # POST /locations
    # POST /locations.json
    def create
      @location = Location.new(params[:location])

      respond_to do |format|
        if @location.save
          format.html { redirect_to [:admin, @location], notice: 'Nueva localidad creada.' }
          format.json { render json: @location, status: :created, location: [:admin, @location] }
        else
          format.html { render action: "new" }
          format.json { render json: @location.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /locations/1
    # PUT /locations/1.json
    def update
      @location = Location.find(params[:id])

      respond_to do |format|
        if @location.update_attributes(params[:location])
          format.html { redirect_to [:admin, @location], notice: 'Localidad actualizada.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @location.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /locations/1
    # DELETE /locations/1.json
    def destroy
      @location = Location.find(params[:id])
      location_name = @location.name
      
      if @location.destroy
        flash[:success] = "La localidad #{location_name.upcase} fue eliminada correctamente."
      else
        flash[:error] = @location.errors.to_a.join("<br />")
      end
      redirect_to admin_root_path(:anchor => 'locations')
    end
  end
end