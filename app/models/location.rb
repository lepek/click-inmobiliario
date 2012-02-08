class Location < ActiveRecord::Base
  
  has_many :properties
  
  validates_presence_of :name
  
  before_destroy :location_with_properties?
  
  private
  
  def location_with_properties?
    errors.add(:base, "La localidad #{name.upcase} no puede ser eliminada ya que posee inmuebles asociados a la misma.") unless properties.count == 0
    errors.blank?
  end
end
