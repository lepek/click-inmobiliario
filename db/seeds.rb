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

dunond = RealEstate.find_by_name('Dunond')
if dunond.nil?
  dunond = RealEstate.create(:name => 'Dunond', :email => 'info@dunond.com.ar')
end

paganini = RealEstate.find_by_name('Paganini')
if paganini.nil?
  paganini = RealEstate.create(:name => 'Paganini', :email => 'info@paganini.com.ar')
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

rafaela = Location.find_by_name('Rafaela')
if rafaela.nil?
  rafaela = Location.create(:name => 'Rafaela')
end

santa_fe = Location.find_by_name('Santa Fe')
if santa_fe.nil?
  roldan = Location.create(:name => 'Santa Fe')
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

# Tipo de puntos de interes

puts 'Seeding POIs types'

school = PoiType.find_by_name('Escuela')
if school.nil?
  school = PoiType.create!(:name => 'Escuela')
  school.icon.store!(File.open(File.join(Rails.root, 'db/seed_images/pois/school.png')))
  school.save!
end

police = PoiType.find_by_name('Policia')
if police.nil?
  police = PoiType.create!(:name => 'Policia')
  police.icon.store!(File.open(File.join(Rails.root, 'db/seed_images/pois/police.png')))
  police.save!
end

hospital = PoiType.find_by_name('Hospital')
if hospital.nil?
  hospital = PoiType.create!(:name => 'Hospital')
  hospital.icon.store!(File.open(File.join(Rails.root, 'db/seed_images/pois/hospital.png')))
  hospital.save!
end

# Puntos de interes

puts 'Seeding POIs'

if Poi.find_by_description('Hospital de Emergencias "Dr. Clemente Álvarez"').nil?
  i = Poi.create!(
      :description => 'Hospital de Emergencias "Dr. Clemente Álvarez"',
      :location_id => rosario.id,
      :poi_type_id => hospital.id,
      :address => 'Av Pellegrini 3205'
  )
end

if Poi.find_by_description('Hospital Provincial del Centenario').nil?
  i = Poi.create!(
      :description => 'Hospital Provincial del Centenario',
      :location_id => rosario.id,
      :poi_type_id => hospital.id,
      :address => 'Urquiza 3101'
  )
end

if Poi.find_by_description('Hospital de Niños Víctor J. Vilela').nil?
  i = Poi.create!(
      :description => 'Hospital de Niños Víctor J. Vilela',
      :location_id => rosario.id,
      :poi_type_id => hospital.id,
      :address => 'Virasoro 1855'
  )
end

if Poi.find_by_description('Centro de Salud Dr. García Piatti').nil?
  i = Poi.create!(
      :description => 'Centro de Salud Dr. García Piatti',
      :location_id => rosario.id,
      :poi_type_id => hospital.id,
      :address => 'Balcarce 3850'
  )
end

if Poi.find_by_description('Maternidad Martin').nil?
  i = Poi.create!(
      :description => 'Maternidad Martin',
      :location_id => rosario.id,
      :poi_type_id => hospital.id,
      :address => 'San Luis 2020'
  )
end

if Poi.find_by_description('Institutos de San Juan Bautista de La Salle').nil?
  i = Poi.create!(
      :description => 'Institutos de San Juan Bautista de La Salle',
      :location_id => rosario.id,
      :poi_type_id => school.id,
      :address => 'Av Mendoza 444'
  )
end

if Poi.find_by_description('Colegio San José').nil?
  i = Poi.create!(
      :description => 'Colegio San José',
      :location_id => rosario.id,
      :poi_type_id => school.id,
      :address => 'Presidente Roca 150'
  )
end

if Poi.find_by_description('Escuela Domingo F. Sarmiento').nil?
  i = Poi.create!(
      :description => 'Escuela Domingo F. Sarmiento',
      :location_id => rosario.id,
      :poi_type_id => school.id,
      :address => '9 de Julio 80'
  )
end

if Poi.find_by_description('Escuela Gral. San Martin').nil?
  i = Poi.create!(
      :description => 'Escuela Gral. San Martin',
      :location_id => rosario.id,
      :poi_type_id => school.id,
      :address => 'Entre Ríos 145'
  )
end

if Poi.find_by_description('Escuela de Enseñanza Media para Adultos 1147').nil?
  i = Poi.create!(
      :description => 'Escuela de Enseñanza Media para Adultos 1147',
      :location_id => rosario.id,
      :poi_type_id => school.id,
      :address => 'Italia 1244'
  )
end

if Poi.find_by_description('Escuela Gral. Manuel Belgrano').nil?
  i = Poi.create!(
      :description => 'Escuela Gral. Manuel Belgrano',
      :location_id => rosario.id,
      :poi_type_id => school.id,
      :address => 'Buenos Aires 1033'
  )
end

if Poi.find_by_description('Escuela Remedios Escalada de San Martín').nil?
  i = Poi.create!(
      :description => 'Escuela Remedios Escalada de San Martín',
      :location_id => rosario.id,
      :poi_type_id => school.id,
      :address => 'Paraguay 1251'
  )
end

if Poi.find_by_description('Policia Federal').nil?
  i = Poi.create!(
      :description => 'Policia Federal',
      :location_id => rosario.id,
      :poi_type_id => police.id,
      :address => '9 de julio 233'
  )
end

if Poi.find_by_description('Seccional 16').nil?
  i = Poi.create!(
      :description => 'Seccional 16',
      :location_id => rosario.id,
      :poi_type_id => police.id,
      :address => 'Ayacucho 3350'
  )
end

if Poi.find_by_description('Seccional 17').nil?
  i = Poi.create!(
      :description => 'Seccional 17',
      :location_id => rosario.id,
      :poi_type_id => police.id,
      :address => 'Donado 947'
  )
end

if Poi.find_by_description('Seccional 01').nil?
  i = Poi.create!(
      :description => 'Seccional 01',
      :location_id => rosario.id,
      :poi_type_id => police.id,
      :address => 'Juan M. de Rosas 1350'
  )
end

if Poi.find_by_description('Seccional 03').nil?
  i = Poi.create!(
      :description => 'Seccional 03',
      :location_id => rosario.id,
      :poi_type_id => police.id,
      :address => 'Dorrego 161'
  )
end

if Poi.find_by_description('Seccional 07').nil?
  i = Poi.create!(
      :description => 'Seccional 07',
      :location_id => rosario.id,
      :poi_type_id => police.id,
      :address => 'Caferata 345'
  )
end

# Inmuebles

puts 'Seeding properties'

images_path = File.join(Rails.root, 'db/seed_images/properties')

if Property.find_by_code('MI001').nil?
  p = Property.create!(
    :code => 'MI001',
    :real_estate_id => fundar.id,
    :description => 'Casa de categoría, ubicada en zona residencial, compuesto por, en planta baja: living comedor amplio con estufa hogar, comedor diario, baño de servicio, cocina con barra desyunadora, lavandería, habitación de servicio con baño instalado completo, pasillo con ante baño y baño instalado completo, tres dormitorios, uno de ellos con placard, el otro con vestidor y baño en suite, galería semicubierta y cochera, en planta alta: habitación amplia de estudio. El inmueble cuenta con calefacción central, escalera de pinotea, carpintería de aluminio con doble vidrio, celosías de madera. Excelente nivel de terminaciones.',
    :price => Money.from_numeric(125000, usd.code),
    :address => 'Moreno 2716',
    :location_id => rosario.id,
    :type_id => casa.id,
    :operation_id => venta.id
  )
  156.times { |i| p.impressions.create(:request_hash => "9beeb36b0bac66e260a231bfcf35e0b8ae7805b07a3ebea763d55778b9e75e5#{i}") }
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
    :description => 'EXCELENTE CASA NUEVA EN BARRIO PRIVADO CON VISTAS AL CORDON DEL PLATA. SUP. TERRENO 2313.53 m2, SUP. CUB. 510 M2 más quincho. CONSTA DE DOS PLANTAS: Planta Baja: Hall recibidor, living-con bar, toilette, gran estar comedor con hogar a leñas, cocina con abundante amoblamiento jhonson, con isla, garage doble a la par con portón automatizado, sala de máquinas, gran suitte con vestidor , baño privado con yacuzzi más ducha. sala de lavado y planchado, patio tendedero. Quincho de 60 m2, con portón automatizado , gran jardín parquizado con árboles añosos. Planta alta: playroom, 4 dormitorios, un baño zonificado, un living-íntimo, balcón. Excelentes vistas. Pisos de porcelanato rústico, y entablonados de pinotea, techos con cabriadas en pinotea, puertas recicladas antiguas excelentes diseño, techos altos, cristales biscelados. Calefacción central por radiantes.Muy luminosa. baños en travertino.',
    :price => Money.from_numeric(650000, ars.code),
    :address => '9 de Julio 1046',
    :location_id => rosario.id,
    :type_id => casa.id,
    :operation_id => venta.id,
    :created_at => 1.month.ago
  )
  126.times { |i| p.impressions.create(:request_hash => "9beeb36b0bac66e260a231bfcf35e0b8ae7805b07a3ebea763d55778b9e75e4#{i}") }
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
    :real_estate_id => fundar.id,
    :description => 'Departamento a estrenar, frontal, en complejo cerrado. el mismo está conformado por dos dormitorios con placares, cocina-equipada con amoblamiento, posee artefacto de cocina. lavadero integrado, instalación para lavarropas, termotanque, baño completo con bañera, balcones, cochera',
    :price => Money.from_numeric(2500, ars.code),
    :address => 'Donado 1098',
    :location_id => rosario.id,
    :type_id => depto.id,
    :operation_id => alquiler.id,
    :created_at => 1.week.ago
  )
  170.times { |i| p.impressions.create(:request_hash => "9beeb36b0bac66e260a231bfcf35e0b8ae7805b07a3ebea763d55778b9e75e3#{i}") }
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
    :real_estate_id => fundar.id,
    :description => 'Semipiso ubicado en calle Pichincha y Rioja, a pocas cuadras del Hospital central y de la terminal de omnibus. Cuenta con tres dormitorios con placares, baño completo y baño de visitas. Gran living comedor en pisos de marmol con balcon y excelente vista a la ciudad. Cocina con comedor diario, lavanderia, dependencias de servicio con baño de servicio. No posee cochera. ',
    :price => Money.from_numeric(1200, ars.code),
    :address => 'Pichincha 937',
    :location_id => rosario.id,
    :type_id => condo.id,
    :operation_id => alquiler.id,
    :created_at => 1.week.ago
  )
  150.times { |i| p.impressions.create(:request_hash => "9beeb36b0bac66e260a231bfcf35e0b8ae7805b07a3ebea763d55778b9e75e2#{i}") }
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
    :price => Money.from_numeric(560000, ars.code),
    :address => 'Alvear 1670',
    :location_id => rosario.id,
    :type_id => casa.id,
    :operation_id => venta.id
  )
  53.times { |i| p.impressions.create(:request_hash => "9beeb36b0bac66e260a231bfcf35e0b8ae7805b07a3ebea763d55778b9e75e1#{i}") }
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
    :description => 'Dúplex en complejo privado con seguridad las 24:00hs. Cuenta en planta baja con: hall de ingreso con placares de guardado estar comedor principal, cocina con lavadero incluído, baño de visitas, patio embaldosado con buenas medidas. En planta alta se encuentra toda la zona nocturna compuesta por 3 dormitorios ,de buenas dimensiones con placares y un baño completo. Terminaciones : pisos y revestimientos cerámicos,techos con correas métalicas. Carpintería en chapa. calefacción por estufas. Todos los ambientes son bien luminosos , ventilados y de buenas dimensiones. El dúplex se encuentra dentro de un complejop compuesto por 17 unidades de vivienda con amplios espacios de uso común de recreación .adémas cuenta con cocheras subterráneas. Las expensas son de $500 (icluyen srguridad todo el día) Tanto el dúplex como el complejo y sus espacios comunes se encuentran en muy buen estado de mantenimiento.',
    :price => Money.from_numeric(110000, usd.code),
    :address => 'Ayacucho 5834',
    :location_id => rosario.id,
    :type_id => condo.id,
    :operation_id => venta.id
  )
  108.times { |i| p.impressions.create(:request_hash => "9beeb36b0bac66e260a231bfcf35e0b8ae7805b07a3ebea763d55778b9e75e0#{i}") }
  Dir.foreach(File.join(images_path, '6')) do |img|
    next if img == '.' or img == '..'
    photo = Photo.create!(
      :file => File.open(File.join(images_path, '6', img)),
      :property_id => p.id
    )
  end
end

if Property.find_by_code('MI007').nil?
  p = Property.create!(
    :code => 'MI007',
    :real_estate_id => fundar.id,
    :description => 'Excelente Departamento en conjunto habitacional. El mismo cuenta con un amplio living comedor con balcón frontal, separado del mismo cocina con abundante amoblamiento de alacena y bajo mesada en melamina con cantos de aluminio, lavadero independiente, 2 dormitorios, el principal en suite con vestidor, baño principal completo con antebaño, dormitorio secundario con placard, cochera doble a la par con sus correspondientes bauleras, ubicado en 4º piso, Superficie Cubierta Propia Total: 81.27 m2.(Torre Norte). Caracreristicas Constructivas: pisos de porcellanatto, aberturas en aluminio blanco, puertas interiores macizas, calefacción central por radiadores.',
    :price => Money.from_numeric(1100, ars.code),
    :address => 'Hipólito Yrigoyen 259',
    :location_id => rafaela.id,
    :type_id => depto.id,
    :operation_id => alquiler.id,
    :created_at => 2.weeks.ago
  )
  35.times { |i| p.impressions.create(:request_hash => "9beeb36b0bac66e260a231bfcf35e0b8ae7805b07a3ebea763d55778b9e75a0#{i}") }
end

if Property.find_by_code('MI008').nil?
  p = Property.create!(
    :code => 'MI008',
    :real_estate_id => dunond.id,
    :description => 'Lo que estabas buscando!! ESPECTACULAR DUPLEX 3 AMBIENTES 80 MTS EXCLUSIVOS EN CALLE SANTIAGO 1644. A metros del parque Independencia y Bv.Oroño. Edificio de escalera. 3er y 4to piso AL FRENTE. Bajas expensas. Orientación este. Excelente construcción. Ambientes totalmente luminosos.',
    :price => Money.from_numeric(120000, usd.code),
    :address => 'Santiago 1600',
    :location_id => rosario.id,
    :type_id => depto.id,
    :operation_id => venta.id,
    :created_at => 3.weeks.ago
  )
  58.times { |i| p.impressions.create(:request_hash => "9beeb36b0bac66e260a231bfcf35e0b8ae7805b07a3ebea763d55778b9e75a1#{i}") }
  Dir.foreach(File.join(images_path, '8')) do |img|
    next if img == '.' or img == '..'
    photo = Photo.create!(
      :file => File.open(File.join(images_path, '8', img)),
      :property_id => p.id
    )
  end
end

if Property.find_by_code('MI009').nil?
  p = Property.create!(
    :code => 'MI009',
    :real_estate_id => pagano.id,
    :description => 'Departamento de un dormitorio con placard, cocina comedor, baño completo, balcon tipo patio de 20 mts2 a estrenar',
    :price => Money.from_numeric(70000, usd.code),
    :address => 'Ituzaingó 1100',
    :location_id => rosario.id,
    :type_id => depto.id,
    :operation_id => venta.id,
    :created_at => 1.weeks.ago
  )
  5.times { |i| p.impressions.create(:request_hash => "9beeb36b0bac66e260a231bfcf35e0b8ae7805b07a3ebea763d55778b9e75a2#{i}") }
  Dir.foreach(File.join(images_path, '9')) do |img|
    next if img == '.' or img == '..'
    photo = Photo.create!(
      :file => File.open(File.join(images_path, '9', img)),
      :property_id => p.id
    )
  end
end

if Property.find_by_code('MI010').nil?
  p = Property.create!(
    :code => 'MI010',
    :real_estate_id => fundar.id,
    :description => 'Excelente departamento de categoria en pleno centro de rosario , balcon de frente y contra frente , solarium , baño con hidromasaje ,cochera fija , quincho , muy bello , perfecta luz y doble circulacion , calefactores en todos las ambientes construccion de categoria , ultima unidad',
    :price => Money.from_numeric(195000, usd.code),
    :address => 'Av San Martin 400',
    :location_id => rosario.id,
    :type_id => depto.id,
    :operation_id => venta.id,
    :created_at => 5.weeks.ago
  )
  15.times { |i| p.impressions.create(:request_hash => "9beeb36b0bac66e260a231bfcf35e0b8ae7805b07a3ebea763d55778b9e75a3#{i}") }
  Dir.foreach(File.join(images_path, '10')) do |img|
    next if img == '.' or img == '..'
    photo = Photo.create!(
      :file => File.open(File.join(images_path, '10', img)),
      :property_id => p.id
    )
  end
end

if Property.find_by_code('MI011').nil?
  p = Property.create!(
    :code => 'MI011',
    :real_estate_id => fundar.id,
    :description => 'Departamento de 3 dormitorios con placares, amplio living, cocina comedor, balcón al frente sobre calle laprida, 1 dormitorio en suite, baño completo, lavadero independiente, puerta blindada, alarma, calefacción individual central terraza con quincho, baños y cocina de uso comun alquiler primeros 6 meses: $2500 alquiler próximos 6 meses: $2700 alquiler segundo año: $3200',
    :price => Money.from_numeric(2500, ars.code),
    :address => 'Laprida 600',
    :location_id => rosario.id,
    :type_id => depto.id,
    :operation_id => alquiler.id,
    :created_at => 2.weeks.ago
  )
  23.times { |i| p.impressions.create(:request_hash => "9beeb36b0bac66e260a231bfcf35e0b8ae7805b07a3ebea763d55778b9e75a4#{i}") }
  Dir.foreach(File.join(images_path, '11')) do |img|
    next if img == '.' or img == '..'
    photo = Photo.create!(
      :file => File.open(File.join(images_path, '11', img)),
      :property_id => p.id
    )
  end
end

if Property.find_by_code('MI012').nil?
  p = Property.create!(
    :code => 'MI012',
    :real_estate_id => dunond.id,
    :description => 'Piso exclusivo dos dormitorios gran living comedor, cocina equipada. dos baños, lavadero independiente. dos balcones. palier privado. cochera. quincho piscina. excelente estado general',
    :price => Money.from_numeric(5000, ars.code),
    :address => 'Laprida 1800',
    :location_id => rosario.id,
    :type_id => depto.id,
    :operation_id => alquiler.id,
    :created_at => 1.weeks.ago
  )
  14.times { |i| p.impressions.create(:request_hash => "9beeb36b0bac66e260a231bfcf35e0b8ae7805b07a3ebea763d55778b9e75a5#{i}") }
  Dir.foreach(File.join(images_path, '12')) do |img|
    next if img == '.' or img == '..'
    photo = Photo.create!(
      :file => File.open(File.join(images_path, '12', img)),
      :property_id => p.id
    )
  end
end

if Property.find_by_code('MI013').nil?
  p = Property.create!(
    :code => 'MI013',
    :real_estate_id => dunond.id,
    :description => 'Consultas por condiciones de contratacion y exhibición al 0341-155702727 / 4267259',
    :price => Money.from_numeric(6000, ars.code),
    :address => 'Italia 800',
    :location_id => rosario.id,
    :type_id => casa.id,
    :operation_id => alquiler.id,
    :created_at => 1.weeks.ago
  )
  14.times { |i| p.impressions.create(:request_hash => "9beeb36b0bac66e260a231bfcf35e0b8ae7805b07a3ebea763d55778b9e75a6#{i}") }
  Dir.foreach(File.join(images_path, '13')) do |img|
    next if img == '.' or img == '..'
    photo = Photo.create!(
      :file => File.open(File.join(images_path, '13', img)),
      :property_id => p.id
    )
  end
end

if Property.find_by_code('MI014').nil?
  p = Property.create!(
    :code => 'MI014',
    :real_estate_id => fundar.id,
    :description => 'ALQUILER COMERCIAL Propiedad desarrollada en una casa en Planta Baja y otra casa en Planta Alta. Magnífica casona antigüa con entradas independientes y conectadas por impecable escalera interna. En planta baja se encuentran un hall ingreso, vestibulo,living recibidor, 4 habitaciones, 4 baños, cocina comedor, living comedor y 2 patios internos. En planta alta se encuentran otras 3 habitaciones, cocina y baño, habitación de servicio, lavadero y terraza. Ideal Instituciones, Bancos, Financieras. MULTINACIONALES',
    :price => Money.from_numeric(7000, usd.code),
    :address => 'Bv. Oroño 50',
    :location_id => rosario.id,
    :type_id => casa.id,
    :operation_id => alquiler.id,
    :created_at => 6.weeks.ago
  )
  24.times { |i| p.impressions.create(:request_hash => "9beeb36b0bac66e260a231bfcf35e0b8ae7805b07a3ebea763d55778b9e75a7#{i}") }
  Dir.foreach(File.join(images_path, '14')) do |img|
    next if img == '.' or img == '..'
    photo = Photo.create!(
      :file => File.open(File.join(images_path, '14', img)),
      :property_id => p.id
    )
  end
end

if Property.find_by_code('MI015').nil?
  p = Property.create!(
    :code => 'MI015',
    :real_estate_id => paganini.id,
    :description => 'Paganini vende cordoba y alsina, casa estilo señorial, impecable estado, 3/4 habitaciones, hall distribuidor de ingreso, cocina comedor y comedor diario, pasaplatos con barra, 3 habitaciones, una con entre piso y una cuarta habitacion en entre piso tipo escritorio o altillo sobre la cochera con acceso por adentro, baño principal reciclado con sanitarios originales y baño de servicio tambien reciclado, patio jardín con pisos mosaicos y cesped, parrillero, terraza, lavadero, dependencias, cochera, aires split y calefactores, 200m2 terreno (8,66 x 23) y 180m2 edificado - contacto: marcos paganini cel: 3415 - 789674 paganini negocios inmobiliarios www paganinirosario com ar',
    :price => Money.from_numeric(220000, usd.code),
    :address => 'Av Córdoba 3800',
    :location_id => rosario.id,
    :type_id => casa.id,
    :operation_id => venta.id,
    :created_at => 4.weeks.ago
  )
  4.times { |i| p.impressions.create(:request_hash => "9beeb36b0bac66e260a231bfcf35e0b8ae7805b07a3ebea763d55778b9e75a8#{i}") }
  Dir.foreach(File.join(images_path, '15')) do |img|
    next if img == '.' or img == '..'
    photo = Photo.create!(
      :file => File.open(File.join(images_path, '15', img)),
      :property_id => p.id
    )
  end
end

if Property.find_by_code('MI016').nil?
  p = Property.create!(
    :code => 'MI016',
    :real_estate_id => dunond.id,
    :description => 'Casa desarrollada en dos plantas 160 m2 cubiertos P B hall ingreso, living, cocina comedor, estar, cochera baño y patio con parrillero P A 3 dormitorios, baño y balcon terraza Escaleras interna y externa, Edificada sobre terreno de 158 m2 Construccion solida, realizada en los años 50 con buenos materiales Ubicada a una cuadra del parque Independencia, excelente barrio, proximo al centro de la ciudad Aceptamos Propuestas: Permuta en Parte de Pago Departamento uno o dos Dormitorio',
    :price => Money.from_numeric(180000, usd.code),
    :address => 'Av Presidente Perón 2900',
    :location_id => rosario.id,
    :type_id => casa.id,
    :operation_id => venta.id,
    :created_at => 7.weeks.ago
  )
  11.times { |i| p.impressions.create(:request_hash => "9beeb36b0bac66e260a231bfcf35e0b8ae7805b07a3ebea763d55778b9e75a9#{i}") }
  Dir.foreach(File.join(images_path, '16')) do |img|
    next if img == '.' or img == '..'
    photo = Photo.create!(
      :file => File.open(File.join(images_path, '16', img)),
      :property_id => p.id
    )
  end
end

# Busquedas

puts 'Seeding searches'

10.times { |i|
  Search.log(
      {
        :location_id => rosario.id,
        :type_id => depto.id,
        :operation_id => venta.id,
        :price => 80000,
        :currency_code => usd.code
      },
      nil
  )
}

12.times { |i|
  Search.log(
      {
        :location_id => rosario.id,
        :type_id => depto.id,
        :operation_id => venta.id,
        :price => 45000,
        :currency_code => usd.code
      },
      nil
  )
}

26.times { |i|
  Search.log(
      {
        :location_id => rosario.id,
        :type_id => depto.id,
        :operation_id => venta.id,
        :price => 165000,
        :currency_code => usd.code
      },
      nil
  )
}

8.times { |i|
  Search.log(
      {
        :location_id => rafaela.id,
        :type_id => depto.id,
        :operation_id => venta.id,
        :price => 30000,
        :currency_code => usd.code
      },
      nil
  )
}