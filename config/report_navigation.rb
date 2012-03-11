# Admin Management menu
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |top|
    top.dom_class = 'sf-menu'
    top.item :admin, '<img src="/assets/nav_icons/reports-icon.png" /> Reportes', "", :if => Proc.new { 
        user_signed_in? && current_ability.can?(:access, :report)
      } do |sub|
      sub.item :visits, 'Visitas', report_path('visits')
      sub.item :visits, 'Localidades', report_path('locations')
      sub.item :visits, 'Publicaciones', report_path('publish')
      sub.item :visits, 'Búsquedas', report_path('search')
      sub.item :visits, 'Precios', report_path('price')
    end
  end
end
