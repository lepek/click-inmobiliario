class Operation < ActiveRecord::Base
  
  has_many :properties
  
  validates_presence_of :name
  
  before_destroy :operation_with_properties?
  
  private
  
  def operation_with_properties?
    errors.add(:base, "La operaci&oacute;n #{name.upcase} no puede ser eliminada ya que posee inmuebles asociados a la misma.") unless properties.count == 0
    errors.blank?
  end
end
