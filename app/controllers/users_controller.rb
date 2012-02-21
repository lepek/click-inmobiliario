# encoding: utf-8

class UsersController < ApplicationController
    before_filter :authenticate_user!, :except => [:new, :create]
    load_and_authorize_resource :only => [:edit, :update, :show]  
  
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
      @user.role = Role.find_by_name('Cliente')
      respond_to do |format|
        if @user.save
          sign_in(@user)
          format.html { redirect_to @user, notice: 'Usuario creado con éxito.' }
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
      if params[:user][:password].blank? && params[:user][:confirm_password].blank?
        result = @user.update_without_password(params[:user])
      else
        result = @user.update_attributes(params[:user])
      end
      respond_to do |format|
        if result
          format.html { redirect_to [:admin, @user], notice: 'Usuario actualizado.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
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

end
