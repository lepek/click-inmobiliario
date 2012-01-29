# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |top|
    #top.item :profile, current_user.username, url_for(:controller => "admin/users", :action => "show"), :if => proc { user_signed_in? }
    #top.item :sign_in, 'Sign in', main_app.sign_in_path, :unless => proc { user_signed_in? }
    #top.item :sign_out, 'Sign out', main_app.sign_out_path, :if => proc { user_signed_in? }
  end
end
