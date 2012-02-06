# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |top|
    
    # I have to evalute it here because current_user may not exist, the x.item :if it's just to control the render
    if user_signed_in?
      top.item :profile, [current_user.first_name, current_user.last_name].compact.join(' ') , main_app.edit_admin_user_path(current_user)
    end
    
    top.item :sign_in, 'Sign in', main_app.new_user_session_path, :unless => Proc.new { user_signed_in? }
    top.item :sign_out, 'Sign out', main_app.destroy_user_session_path, :method => :delete, :if => Proc.new { user_signed_in? }
  end
end
