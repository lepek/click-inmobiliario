class PoiType < ActiveRecord::Base
  
  has_many :pois
  
  validates_presence_of :name
  
  mount_uploader :icon, IconUploader
  
  before_destroy :poi_type_with_pois?
  
  private
  
  def poi_type_with_pois?
    errors.add(:base, "El tipo de punto de interes #{name.upcase} no puede ser eliminado ya que posee puntos de interes asociados al mismo.") unless pois.count == 0
    errors.blank?
  end
  
end
