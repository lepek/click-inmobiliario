class Currency < ActiveRecord::Base
  
  has_many :properties
  
  validates_presence_of :name
  validates_presence_of :code
  
  before_destroy :currency_with_properties?
  
  private
  
  def currency_with_properties?
    errors.add(:base, "La moneda #{name.upcase} no puede ser eliminada ya que posee inmuebles asociados a la misma.") unless properties.count == 0
    errors.blank?
  end
    
end
