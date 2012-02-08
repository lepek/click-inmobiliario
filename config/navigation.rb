# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |top|

    top.item :register, '<img src="/assets/nav_icons/sign-up-icon.png" /> Registrarse', main_app.new_user_path, :unless => Proc.new { user_signed_in? }

    # I have to evalute it here because current_user may not exist, the x.item :if it's just to control the render
    if user_signed_in?
      top.item :profile, '<img src="/assets/nav_icons/user-icon.png" />' + [current_user.first_name, current_user.last_name].compact.join(' ') , main_app.edit_user_path(current_user)
    end
    
    top.item :sign_in, '<img src="/assets/nav_icons/keys-icon.png" /> Ingresar', main_app.new_user_session_path, :unless => Proc.new { user_signed_in? }
    top.item :sign_out, '<img src="/assets/nav_icons/logout.png" /> Cerrar Sesión', main_app.destroy_user_session_path, :method => :delete, :if => Proc.new { user_signed_in? }
  end
end