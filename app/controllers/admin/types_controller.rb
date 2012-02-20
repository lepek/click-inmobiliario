module Admin
  class TypesController < Admin::ApplicationController
    load_and_authorize_resource
    
    # GET /types
    # GET /types.json
    def index
      @types = Type.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @types }
      end
    end

    # GET /types/1
    # GET /types/1.json
    def show
      @type = Type.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @type }
      end
    end

    # GET /types/new
    # GET /types/new.json
    def new
      @type = Type.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @type }
      end
    end

    # GET /types/1/edit
    def edit
      @type = Type.find(params[:id])
    end

    # POST /types
    # POST /types.json
    def create
      @type = Type.new(params[:type])

      respond_to do |format|
        if @type.save
          format.html { redirect_to [:admin, @type], notice: 'Nuevo tipo de inmueble creado.' }
          format.json { render json: @type, status: :created, location: [:admin, @type] }
        else
          format.html { render action: "new" }
          format.json { render json: @type.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /types/1
    # PUT /types/1.json
    def update
      @type = Type.find(params[:id])

      respond_to do |format|
        if @type.update_attributes(params[:type])
          format.html { redirect_to [:admin, @type], notice: 'Tipo de inmueble actualizado.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @type.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /types/1
    # DELETE /types/1.json
    def destroy
      @type = Type.find(params[:id])
      type_name = @type.name
      
      if @type.destroy
        flash[:success] = "El tipo de inmueble #{type_name.upcase} fue eliminado correctamente."
      else
        flash[:error] = @type.errors.to_a.join("<br />")
      end
      redirect_to admin_root_path(:anchor => 'types')
    end

  end
end