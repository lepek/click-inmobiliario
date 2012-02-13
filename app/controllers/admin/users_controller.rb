module Admin
  class UsersController < Admin::ApplicationController
    
    # GET /users
    # GET /users.json
    def index
      @users = User.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @users }
      end
    end

    # GET /users/1
    # GET /users/1.json
    def show
      @user = User.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @user }
      end
    end

    # GET /users/new
    # GET /users/new.json
    def new
      @user = User.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @user }
      end
    end

    # GET /users/1/edit
    def edit
      @user = User.find(params[:id])
    end

    # POST /users
    # POST /users.json
    def create
      @user = User.new(params[:user])

      respond_to do |format|
        if @user.save
          format.html { redirect_to [:admin, @user], notice: 'Nuevo usuario creado.' }
          format.json { render json: @user, status: :created, location: [:admin, @user] }
        else
          format.html { render action: "new" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /users/1
    # PUT /users/1.json
    def update
      @user = User.find(params[:id])

      respond_to do |format|
        if @user.update_attributes(params[:user])
          format.html { redirect_to [:admin, @user], notice: 'Usuario actualizado.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /users/1
    # DELETE /users/1.json
    def destroy
      @user = User.find(params[:id])
      user_full_name = "#{@user.first_name + ' ' + @user.last_name}"
      @user.destroy

      respond_to do |format|
        format.html do
          flash[:success] = "El usuario #{user_full_name.upcase} fue eliminado correctamente." 
          redirect_to admin_root_path(:anchor => 'users')
        end
      end
    end
  end
end