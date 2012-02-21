# Admin Management menu
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |top|
    top.dom_class = 'sf-menu'
    top.item :admin, '<img src="/assets/nav_icons/admin-icon.png" /> Administración', "/admin", :if => Proc.new { 
        user_signed_in? && current_ability.can?(:access, :admin_module)
      } do |sub|
      sub.item :properties, 'Inmuebles', admin_root_path(:anchor => 'properties'), :if => proc {
        current_ability.can? :manage, Property
      }
      sub.item :real_estates, 'Inmobiliarias', admin_root_path(:anchor => 'real_estates'), :if => proc {
        current_ability.can? :manage, RealEstate
      }
      sub.item :users, 'Usuarios', admin_root_path(:anchor => 'users'), :if => proc {
        current_ability.can? :manage, User
      }
      sub.item :currencies, 'Monedas', admin_root_path(:anchor => 'currencies'), :if => proc {
        current_ability.can? :manage, Currency
      }
      sub.item :locations, 'Localidades', admin_root_path(:anchor => 'locations'), :if => proc {
        current_ability.can? :manage, Location
      }
      sub.item :operations, 'Operaciones', admin_root_path(:anchor => 'operations'), :if => proc {
        current_ability.can? :manage, Operation
      }
      sub.item :types, 'Tipos de Inmueble', admin_root_path(:anchor => 'types'), :if => proc {
        current_ability.can? :manage, Type
      }
    end
  end
end
