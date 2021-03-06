# encoding: utf-8

module Admin
  class OperationsController < Admin::ApplicationController
    load_and_authorize_resource
    
    # GET /operations
    # GET /operations.json
    def index
      @operations = Operation.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @operations }
      end
    end

    # GET /operations/1
    # GET /operations/1.json
    def show
      @operation = Operation.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @operation }
      end
    end

    # GET /operations/new
    # GET /operations/new.json
    def new
      @operation = Operation.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @operation }
      end
    end

    # GET /operations/1/edit
    def edit
      @operation = Operation.find(params[:id])
    end

    # POST /operations
    # POST /operations.json
    def create
      @operation = Operation.new(params[:operation])

      respond_to do |format|
        if @operation.save
          format.html { redirect_to [:admin, @operation], notice: 'Nuevo tipo de operación creado.' }
          format.json { render json: @operation, status: :created, location: [:admin, @operation] }
        else
          format.html { render action: "new" }
          format.json { render json: @operation.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /operations/1
    # PUT /operations/1.json
    def update
      @operation = Operation.find(params[:id])

      respond_to do |format|
        if @operation.update_attributes(params[:operation])
          format.html { redirect_to [:admin, @operation], notice: 'Tipo de operación actualizado.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @operation.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /operations/1
    # DELETE /operations/1.json
    def destroy
      @operation = Operation.find(params[:id])
      operation_name = @operation.name
      
      if @operation.destroy
        flash[:success] = "El tipo de operaci&oacute;n #{operation_name.upcase} fue eliminado correctamente."
      else
        flash[:error] = @operation.errors.to_a.join("<br />")
      end
      redirect_to admin_root_path(:anchor => 'operations')
    end

  end
end