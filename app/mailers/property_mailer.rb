class PropertyMailer < ActionMailer::Base
  default from: "contacto@click-inmobiliario.com"
  
  def contact_email(property, user, comments)
    @property = property
    @user = user
    @comments = comments  
    mail(
      :to => property.real_estate.email, 
      :subject => "Contacto por la propiedad de #{@property.address}, #{@property.location.name}"
    )
  end
end
