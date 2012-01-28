# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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

rosario = Location.find_by_name('Rosario')
if rosario.nil?
  Location.create(:name => 'Rosario')
end

vgg = Location.find_by_name('Villa Gobernador Galvez')
if vgg.nil?
  Location.create(:name => 'Villa Gobernador Galvez')
end