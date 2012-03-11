# encoding: utf-8

module Admin
  class PoiTypesController < Admin::ApplicationController
    load_and_authorize_resource
    
    # GET /poi_types
    # GET /poi_types.json
    def index
      @poi_types = PoiType.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @poi_types }
      end
    end

    # GET /poi_types/1
    # GET /poi_types/1.json
    def show
      @poi_type = PoiType.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @poi_type }
      end
    end

    # GET /poi_types/new
    # GET /poi_types/new.json
    def new
      @poi_type = PoiType.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @poi_type }
      end
    end

    # GET /poi_types/1/edit
    def edit
      @poi_type = PoiType.find(params[:id])
    end

    # POST /poi_types
    # POST /poi_types.json
    def create
      @poi_type = PoiType.new(params[:poi_type])

      respond_to do |format|
        if @poi_type.save
          format.html { redirect_to [:admin, @poi_type], notice: 'Nuevo tipo de punto de interés creado.' }
          format.json { render json: @poi_type, status: :created, location: [:admin, @poi_type] }
        else
          format.html { render action: "new" }
          format.json { render json: @poi_type.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /poi_types/1
    # PUT /poi_types/1.json
    def update
      @poi_type = PoiType.find(params[:id])

      respond_to do |format|
        if @poi_type.update_attributes(params[:poi_type])
          format.html { redirect_to [:admin, @poi_type], notice: 'Tipo de punto de interés actualizado.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @poi_type.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /poi_types/1
    # DELETE /poi_types/1.json
    def destroy
      @poi_type = PoiType.find(params[:id])
      poi_type_name = @poi_type.name
      
      if @poi_type.destroy
        flash[:success] = "El tipo de punto de inter&eacute;s #{poi_type_name.upcase} fue eliminado correctamente."
      else
        flash[:error] = @poi_type.errors.to_a.join("<br />")
      end
      redirect_to admin_root_path(:anchor => 'poi_types')
    end

  end
end