# encoding: utf-8

#Roles

puts 'Seeding roles'

admin_role = Role.find_by_name('Admin')
if admin_role.nil?
  admin_role = Role.create(
    :name => 'Admin', 
    :description => 'Administrador', 
  )
end

inmobiliaria_role = Role.find_by_name('Inmobiliaria')
if inmobiliaria_role.nil?
  inmobiliaria_role = Role.create(
    :name => 'Inmobiliaria', 
    :description => 'Inmobiliaria' 
  )
end

client_role = Role.find_by_name('Cliente')
if client_role.nil?
  client_role = Role.create(
    :name => 'Cliente', 
    :description => 'Cliente y/o visitante web' 
  )
end

# Inmobiliarias

puts 'Seeding real estates'

fundar = RealEstate.find_by_name('Fundar')
if fundar.nil?
  fundar = RealEstate.create(:name => 'Fundar', :email => 'info@fundar.com.ar')
end

pagano = RealEstate.find_by_name('Pagano Luraschi')
if pagano.nil?
  pagano = RealEstate.create(:name => 'Pagano Luraschi', :email => 'info@pagano.com.ar')
end

# Usuarios

puts 'Seeding users'

client_user = User.find_by_email('mbianculli@gmail.com')
if client_user.nil?
  User.create(
    :first_name => 'Martin', 
    :last_name => 'Bianculli', 
    :email => 'mbianculli@gmail.com', 
    :password => 'foo',
    :password_confirmation => 'foo',
    :role_id => client_role.id
  )
end

admin_user = User.find_by_email('admin@gmail.com')
if admin_user.nil?
  User.create(
    :first_name => 'Administrator', 
    :last_name => 'Site', 
    :email => 'admin@gmail.com', 
    :password => 'foo',
    :password_confirmation => 'foo',
    :role_id => admin_role.id
  )
end

inmobiliaria_user = User.find_by_email('inmobiliaria@gmail.com')
if inmobiliaria_user.nil?
  User.create(
    :first_name => 'Junacito', 
    :last_name => 'Fundar', 
    :email => 'fundar@gmail.com', 
    :password => 'foo',
    :password_confirmation => 'foo',
    :role_id => inmobiliaria_role.id,
    :real_estate_id => fundar.id
  )
end

# Localidades

puts 'Seeding locations'

rosario = Location.find_by_name('Rosario')
if rosario.nil?
  rosario = Location.create(:name => 'Rosario')
end

vgg = Location.find_by_name('Villa Gobernador Galvez')
if vgg.nil?
  vgg = Location.create(:name => 'Villa Gobernador Galvez')
end

funes = Location.find_by_name('Funes')
if funes.nil?
  funes = Location.create(:name => 'Funes')
end

roldan = Location.find_by_name('Roldan')
if roldan.nil?
  roldan = Location.create(:name => 'Roldan')
end

san_lorenzo = Location.find_by_name('San Lorenzo')
if san_lorenzo.nil?
  san_lorenzo = Location.create(:name => 'San Lorenzo')
end

casilda = Location.find_by_name('Casilda')
if casilda.nil?
  casilda = Location.create(:name => 'Casilda')
end

# Moneda

puts 'Seeding currencies'

ars = Currency.find_by_code('ARS')
if ars.nil?
  ars = Currency.create(:name => 'Pesos', :code => 'ARS', :symbol => '$')
end

usd = Currency.find_by_code('USD')
if usd.nil?
  usd = Currency.create(:name => 'Dolares', :code => 'USD', :symbol => 'U$S')
end

# Tipo de Propiedad

puts 'Seeding property types'

depto = Type.find_by_name('Departamento')
if depto.nil?
  depto = Type.create!(:name => 'Departamento')
  depto.icon.store!(File.open(File.join(Rails.root, 'db/seed_images/types/apartment.png')))
  depto.save!
end

casa = Type.find_by_name('Casa')
if casa.nil?
  casa = Type.create(:name => 'Casa')
  casa.icon.store!(File.open(File.join(Rails.root, 'db/seed_images/types/house.png')))
  casa.save!
end

condo = Type.find_by_name('Condominio')
if condo.nil?
  condo = Type.create(:name => 'Condominio')
  condo.icon.store!(File.open(File.join(Rails.root, 'db/seed_images/types/condominium.png')))
  condo.save!
end

# Tipo de Operacion

puts 'Seeding operation types'

venta = Operation.find_by_name('Venta')
if venta.nil?
  venta = Operation.create(:name => 'Venta')
end

alquiler = Operation.find_by_name('Alquiler')
if alquiler.nil?
  alquiler = Operation.create(:name => 'Alquiler')
end

# Inmuebles

puts 'Seeding properties'

images_path = File.join(Rails.root, 'db/seed_images/properties')

if Property.find_by_code('MI001').nil?
  p = Property.create!(
    :code => 'MI001',
    :real_estate_id => fundar.id,
    :description => 'Casa de categoría, ubicada en zona residencial, compuesto por, en planta baja: living comedor amplio con estufa hogar, comedor diario, baño de servicio, cocina con barra desyunadora, lavandería, habitación de servicio con baño instalado completo, pasillo con ante baño y baño instalado completo, tres dormitorios, uno de ellos con placard, el otro con vestidor y baño en suite, galería semicubierta y cochera, en planta alta: habitación amplia de estudio. El inmueble cuenta con calefacción central, escalera de pinotea, carpintería de aluminio con doble vidrio, celosías de madera. Excelente nivel de terminaciones.',
    :price => '125000',
    :currency_id => usd.id,
    :address => 'Moreno 2716',
    :location_id => rosario.id,
    :type_id => casa.id,
    :operation_id => venta.id
  )
  Dir.foreach(File.join(images_path, '1')) do |img|
    next if img == '.' or img == '..'
    photo = Photo.create!(
      :file => File.open(File.join(images_path, '1', img)),
      :property_id => p.id
    )
  end
end

if Property.find_by_code('MI002').nil?
  p = Property.create!(
    :code => 'MI002',
    :real_estate_id => fundar.id,
    :description => 'EXCELENTE CASA NUEVA EN BARRIO PRIVADO CON VISTAS AL CORDON DEL PLATA. SUP. TERRENO 2313.53 m2, SUP. CUB. 510 M2 más quincho. CONSTA DE DOS PLANTAS: Planta Baja: Hall recibidor, living-con bar, toilette, gran estar comedor con hogar a leñas, cocina con abundante amoblamiento jhonson, con isla, garage doble a la par con portón automatizado, sala de máquinas, gran suitte con vestidor , baño privado con yacuzzi más ducha. sala de lavado y planchado, patio tendedero. Quincho de 60 m2, con portón automatizado , gran jardín parquizado con árboles añosos. Planta ÃƒÂ¤lta: playrrom, 4 dormitorios, un baño zonificado, un living-íntimo, balcón. Excelentes vistas. Pisos de porcelanato rústico, y entablonados de pinotea, techos con cabriadas en pinotea, puertas recicladas antiguas excelentes diseño, techos altos, cristales biscelados. Calefacción central por radiantes.Muy luminosa. baños en travertino.',
    :price => '650000',
    :currency_id => usd.id,
    :address => '9 de Julio 1046',
    :location_id => rosario.id,
    :type_id => casa.id,
    :operation_id => venta.id
  )
  Dir.foreach(File.join(images_path, '2')) do |img|
    next if img == '.' or img == '..'
    photo = Photo.create!(
      :file => File.open(File.join(images_path, '2', img)),
      :property_id => p.id
    )
  end
end

if Property.find_by_code('MI003').nil?
  p = Property.create!(
    :code => 'MI003',
    :real_estate_id => pagano.id,
    :description => 'Departamento a estrenar, frontal, en complejo cerrado. el mismo está conformado por dos dormitorios con placares, cocina-equipada con amoblamiento, posee artefacto de cocina. lavadero integrado, instalación para lavarropas, termotanque, baño completo con bañera, balcones, cochera',
    :price => '2500',
    :currency_id => ars.id,
    :address => 'Donado 1098',
    :location_id => rosario.id,
    :type_id => depto.id,
    :operation_id => alquiler.id
  )
  Dir.foreach(File.join(images_path, '3')) do |img|
    next if img == '.' or img == '..'
    photo = Photo.create!(
      :file => File.open(File.join(images_path, '3', img)),
      :property_id => p.id
    )
  end
end

if Property.find_by_code('MI004').nil?
  p = Property.create!(
    :code => 'MI004',
    :real_estate_id => pagano.id,
    :description => 'Semipiso ubicado en calle Pichincha y Rioja, a pocas cuadras del Hospital central y de la terminal de omnibus. Cuenta con tres dormitorios con placares, baño completo y baño de visitas. Gran living comedor en pisos de marmol con balcon y excelente vista a la ciudad. Cocina con comedor diario, lavanderia, dependencias de servicio con baño de servicio. No posee cochera. ',
    :price => '1200',
    :currency_id => ars.id,
    :address => 'Pichincha 937',
    :location_id => rosario.id,
    :type_id => condo.id,
    :operation_id => alquiler.id
  )
  Dir.foreach(File.join(images_path, '4')) do |img|
    next if img == '.' or img == '..'
    photo = Photo.create!(
      :file => File.open(File.join(images_path, '4', img)),
      :property_id => p.id
    )
  end
end

if Property.find_by_code('MI005').nil?
  p = Property.create!(
    :code => 'MI005',
    :real_estate_id => pagano.id,
    :description => 'Magnífica ubicación comercial y residencial, frente al museo Castagnino, propiedad semi estrenar..!! Posee 2 Dormitorios amplios con placares de doble rulemán y ventanas con rejas, baño principal completo con ante baño y vanitory, sector de vestidor o sala planchado, living comedor, cocina con amoblamientos completos y desayunador, cochera amplia techada con capacidad para guardar una camioneta y acceso común a terraza con vistas varias.Mejoras: Se entrega con cocina, calefactor, termotanque, aberturas con rejas, portero eléctrico visor, alarma, portón de complejo automatizado, espacios comunes con luces sectorizadas de encendido automático, matafuegos y luces de emergencia.',
    :price => '560000',
    :currency_id => ars.id,
    :address => 'Alvear 1670',
    :location_id => rosario.id,
    :type_id => casa.id,
    :operation_id => venta.id
  )
  Dir.foreach(File.join(images_path, '5')) do |img|
    next if img == '.' or img == '..'
    photo = Photo.create!(
      :file => File.open(File.join(images_path, '5', img)),
      :property_id => p.id
    )
  end
end

if Property.find_by_code('MI006').nil?
  p = Property.create!(
    :code => 'MI006',
    :real_estate_id => pagano.id,
    :description => 'Dúplex en complejo privado con seguridad las 24:00hs. Cuenta en planta baja con:hall de ingreso con placares de guardado estar comedor principal, cocina con lavadero incluído, baño de visitas, patio embaldosado con buenas medidas. En planta alta se encuentra toda la zona nocturna compuesta por 3 dormitorios ,de buenas dimensiones con placares y un baño completo. Terminaciones : pisos y revestimientos cerámicos,techos con correas métalicas. Carpintería en chapa. calefacción por estufas. Todos los ambientes son bien luminosos , ventilados y de buenas dimensiones. El dúplex se encuentra dentro de un complejop compuesto por 17 unidades de vivienda con amplios espacios de uso común de recreación .adémas cuenta con cocheras subterráneas. Las expensas son de $500 (icluyen srguridad todo el día) Tanto el dúplex como el complejo y sus espacios comunes se encuentran en muy buen estado de mantenimiento.',
    :price => '110000',
    :currency_id => usd.id,
    :address => 'Ayacucho 5834',
    :location_id => rosario.id,
    :type_id => condo.id,
    :operation_id => venta.id
  )
  Dir.foreach(File.join(images_path, '6')) do |img|
    next if img == '.' or img == '..'
    photo = Photo.create!(
      :file => File.open(File.join(images_path, '6', img)),
      :property_id => p.id
    )
  end
end