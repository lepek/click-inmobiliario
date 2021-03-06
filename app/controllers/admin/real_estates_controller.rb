module Admin
  class RealEstatesController < Admin::ApplicationController
    load_and_authorize_resource
    
    # GET /real_estates
    # GET /real_estates.json
    def index
      @real_estates = RealEstate.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @real_estates }
      end
    end

    # GET /real_estates/1
    # GET /real_estates/1.json
    def show
      @real_estate = RealEstate.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @real_estate }
      end
    end

    # GET /real_estates/new
    # GET /real_estates/new.json
    def new
      @real_estate = RealEstate.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @real_estate }
      end
    end

    # GET /real_estates/1/edit
    def edit
      @real_estate = RealEstate.find(params[:id])
    end

    # POST /real_estates
    # POST /real_estates.json
    def create
      @real_estate = RealEstate.new(params[:real_estate])

      respond_to do |format|
        if @real_estate.save
          format.html { redirect_to [:admin, @real_estate], notice: 'Nueva inmobiliaria creada.' }
          format.json { render json: @real_estate, status: :created, location: [:admin, @real_estate] }
        else
          format.html { render action: "new" }
          format.json { render json: @real_estate.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /real_estates/1
    # PUT /real_estates/1.json
    def update
      @real_estate = RealEstate.find(params[:id])

      respond_to do |format|
        if @real_estate.update_attributes(params[:real_estate])
          format.html { redirect_to [:admin, @real_estate], notice: 'Inmobiliaria actualizada.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @real_estate.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /real_estates/1
    # DELETE /real_estates/1.json
    def destroy
      @real_estate = RealEstate.find(params[:id])
      real_estate_name = @real_estate.name

      if @real_estate.destroy
        flash[:success] = "La inmobiliaria #{real_estate_name.upcase} fue eliminada correctamente."
      else
        flash[:error] = @real_estate.errors.to_a.join("<br />")
      end
      redirect_to admin_root_path(:anchor => 'real-estates')
    end

  end
end