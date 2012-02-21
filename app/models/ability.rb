class Ability
  include CanCan::Ability

  def initialize(user)
    @user = (user || User.new) # in case of guest
    set_permissions_for_any_role
    if @user.role.name == 'Admin'
      set_permissions_for_admin
    elsif @user.role.name == 'Cliente'
      set_permissions_for_cliente
    elsif @user.role.name == 'Inmobiliaria'
      set_permissions_for_inmobiliaria
    end
  end
  
  private
    
    def set_permissions_for_any_role
      can [:read, :update], User, :id => @user.id
    end
    
    def set_permissions_for_inmobiliaria
      can [:access, :read], :report
      can :access, :admin_module
      can :manage, Property, :real_estate_id => @user.real_estate_id
      can :read, RealEstate, :id => @user.real_estate_id
    end
    
    def set_permissions_for_cliente
      # Puede agregar a favoritos y contactar a la inmobiliaria  
    end
    
    def set_permissions_for_admin
      can :manage, [Currency, Location, Operation, Property, RealEstate, Type, User]
      can :access, :admin_module
    end
  
end
