class Type < ActiveRecord::Base
  
  has_many :properties
  
  validates_presence_of :name
  
  mount_uploader :icon, IconUploader
  
  before_destroy :type_with_properties?
  
  private
  
  def type_with_properties?
    errors.add(:base, "El tipo de inmueble #{name.upcase} no puede ser eliminado ya que posee inmuebles asociados al mismo.") unless properties.count == 0
    errors.blank?
  end
  
end
