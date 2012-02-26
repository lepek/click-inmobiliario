class Poi < ActiveRecord::Base

  belongs_to :location
  belongs_to :poi_type

  # roughly speaking sets list of model protected attributes to []
  # making all attributes accessible while mass-assignment
  attr_protected

  acts_as_gmappable :process_geocoding => true, :check_process => false, :address => :full_address

  validates_presence_of :address
  validates_presence_of :description
  validates_presence_of :location
  validates_presence_of :poi_type

  def self.search(conditions)
    query = []
    query << 'location_id = :location_id' if conditions[:location_id]
    query << 'poi_type_id = :poi_type_id' if conditions[:poi_type_id]
    pois = Poi.where(query.compact.join(' AND '), conditions)
  end

  def full_address
    [address, location.name, 'Argentina'].compact.join(', ')
  end

  def gmaps4rails_marker_picture
      {
        "picture" => poi_type.icon.url,
        "width" => poi_type.icon.getWidth,
        "height" => poi_type.icon.getHeight
      }
  end

  def gmaps4rails_infowindow
    ActionController::Base.new.send(:render_to_string, :partial => 'index/poi_infowindow', :locals => { :poi => self })
  end
  
end
