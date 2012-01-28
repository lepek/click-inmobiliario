class Property < ActiveRecord::Base
  
  belongs_to :location
  
  geocoded_by :full_address
  
  # auto-fetch coordinates
  after_validation :geocode
  
  def full_address
    [address, location.name, 'Argentina'].compact.join(', ')
  end
  
end
