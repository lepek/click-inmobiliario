# Admin Management menu
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |top|
    top.dom_class = 'sf-menu'
    top.item :admin, '<img src="/assets/nav_icons/favorite.png" /> Favoritos', "/properties/favorites_list", :if => Proc.new { user_signed_in? }
  end
end
