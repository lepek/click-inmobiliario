# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Usuarios

user = User.find_by_email('mbianculli@gmail.com')
if user.nil?
  User.create(
    :first_name => 'Martin', 
    :last_name => 'Bianculli', 
    :email => 'mbianculli@gmail.com', 
    :password => 'foo',
    :password_confirmation => 'foo'
  )
end

# Localidades

rosario = Location.find_by_name('Rosario')
if rosario.nil?
  Location.create(:name => 'Rosario')
end

vgg = Location.find_by_name('Villa Gobernador Galvez')
if vgg.nil?
  Location.create(:name => 'Villa Gobernador Galvez')
end

# Moneda

ars = Currency.find_by_code('ARS')
if ars.nil?
  Currency.create(:name => 'Pesos', :code => 'ARS')
end

usd = Currency.find_by_code('USD')
if usd.nil?
  Currency.create(:name => 'Dolares', :code => 'USD')
end

# Tipo de Propiedad

depto = Type.find_by_name('Departamento')
if depto.nil?
  Type.create(:name => 'Departamento')
end

casa = Type.find_by_name('Casa')
if casa.nil?
  Type.create(:name => 'Casa')
end

# Tipo de Operacion

venta = Operation.find_by_name('Venta')
if venta.nil?
  Operation.create(:name => 'Venta')
end

alquiler = Operation.find_by_name('Alquiler')
if alquiler.nil?
  Operation.create(:name => 'Alquiler')
end

# Inmobiliarias

fundar = RealEstate.find_by_name('Fundar')
if fundar.nil?
  RealEstate.create(:name => 'Fundar', :email => 'info@fundar.com.ar')
end

pagano = RealEstate.find_by_name('Pagano Luraschi')
if pagano.nil?
  RealEstate.create(:name => 'Pagano Luraschi', :email => 'info@pagano.com.ar')
end