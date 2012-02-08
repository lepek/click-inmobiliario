# Admin Management menu
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |top|
    top.dom_class = 'sf-menu'
    top.item :admin, '<img src="/assets/nav_icons/admin-icon.png" /> Administración', "/admin" do |sub|
      sub.item :properties, 'Inmuebles', admin_root_path(:anchor => 'properties')
      sub.item :real_estates, 'Inmobiliarias', admin_root_path(:anchor => 'real_estates')
      sub.item :users, 'Usuarios', admin_root_path(:anchor => 'users')
      sub.item :currencies, 'Monedas', admin_root_path(:anchor => 'currencies')
      sub.item :locations, 'Localidades', admin_root_path(:anchor => 'locations')
      sub.item :operations, 'Operaciones', admin_root_path(:anchor => 'operations')
      sub.item :types, 'Tipos de Inmueble', admin_root_path(:anchor => 'types')
    end
  end
end
