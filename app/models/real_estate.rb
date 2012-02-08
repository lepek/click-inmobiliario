class RealEstate < ActiveRecord::Base
  
  has_many :properties
  
  validates_presence_of :name
  validates_presence_of :email
  validates_uniqueness_of :email
  
  before_destroy :real_estate_with_properties?
  
  private
  
  def real_estate_with_properties?
    errors.add(:base, "La inmobiliaria #{name.upcase} no puede ser eliminada ya que posee inmuebles asociados a la misma.") unless properties.count == 0
    errors.blank?
  end
end
