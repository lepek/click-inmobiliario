module Admin
  class PropertiesController < Admin::ApplicationController
    # GET /properties
    # GET /properties.json
    def index
      @properties = Property.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @properties }
      end
    end

    # GET /properties/1
    # GET /properties/1.json
    def show
      @property = Property.find(params[:id])
      @json = @property.to_gmaps4rails
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @property }
      end
    end

    # GET /properties/new
    # GET /properties/new.json
    def new
      @property = Property.new
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @property }
      end
    end

    # GET /properties/1/edit
    def edit
      @property = Property.find(params[:id])
    end

    # POST /properties
    # POST /properties.json
    def create
      @property = Property.new(params[:property])

      respond_to do |format|
        if @property.save
          format.html { redirect_to [:admin, @property], notice: 'Nuevo inmueble creado.' }
          format.json { render json: @property, status: :created, location: [:admin, @property] }
        else
          format.html { render action: "new" }
          format.json { render json: @property.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /properties/1
    # PUT /properties/1.json
    def update
      @property = Property.find(params[:id])

      params[:property][:photos_attributes].each_key { |key|
        if params[:property][:photos_attributes][key.to_sym][:remove_file] == "1"
          @photo = Photo.find(params[:property][:photos_attributes][key.to_sym][:id])
          @photo.remove_file!
          @photo.destroy
          params[:property][:photos_attributes].delete(key.to_sym)
        end
      }

      respond_to do |format|
        if @property.update_attributes(params[:property])
          format.html { redirect_to [:admin, @property], notice: 'Inmueble actualizado.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @property.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /properties/1
    # DELETE /properties/1.json
    def destroy
      @property = Property.find(params[:id])
      property_address = @property.address
      @property.destroy

      respond_to do |format|
        format.html do
          flash[:success] = "El inmueble ubicado en #{property_address.upcase} fue eliminado correctamente." 
          redirect_to admin_root_path(:anchor => 'properties')
        end
      end
    end
  end
end