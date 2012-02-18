# Admin Management menu
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |top|
    top.dom_class = 'sf-menu'
    top.item :admin, '<img src="/assets/nav_icons/reports-icon.png" /> Reportes', "", :if => Proc.new { user_signed_in? } do |sub|
      sub.item :visits, 'Visitas', report_path('visits')
    end
  end
end
