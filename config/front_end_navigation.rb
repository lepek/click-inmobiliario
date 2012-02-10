# Admin Management menu
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |top|
    top.dom_class = 'sf-menu'
    top.item :admin, '<img src="/assets/nav_icons/home-icon.png" /> Inicio', root_path
  end
end
