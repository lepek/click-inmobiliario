class Property < ActiveRecord::Base

  belongs_to :location
  belongs_to :type
  belongs_to :currency
  belongs_to :operation
  belongs_to :real_estate

  has_many :photos, :dependent => :destroy
  has_many :favorites
  has_many :users, :through => :favorites 

  accepts_nested_attributes_for :photos

  is_impressionable

  # roughly speaking sets list of model protected attributes to []
  # making all attributes accessible while mass-assignment
  attr_protected

  acts_as_gmappable :process_geocoding => true, :check_process => false, :address => :full_address

  validates_presence_of :code
  validates_uniqueness_of :code
  validates_presence_of :price
  validates_presence_of :address
  validates_presence_of :description
  validates_presence_of :location
  validates_presence_of :type
  validates_presence_of :currency
  validates_presence_of :operation
  validates_presence_of :real_estate

  def full_address
    [address, location.name, 'Argentina'].compact.join(', ')
  end

  def gmaps4rails_marker_picture
      {
        "picture" => type.icon.url,
        "width" => type.icon.getWidth,
        "height" => type.icon.getHeight
      }
  end

  def gmaps4rails_infowindow
    ActionController::Base.new.send(:render_to_string, :partial => 'index/infowindow', :locals => { :property => self })
  end

  def self.search(conditions)
    query = []
    query << 'location_id = :location_id' unless conditions[:location_id] <= 0
    query << 'type_id = :type_id' unless conditions[:type_id] <= 0
    query << 'operation_id = :operation_id' unless conditions[:operation_id] <= 0
    query << 'currency_id = :currency_id' unless conditions[:currency_id] <= 0
    query << 'price < :price' unless conditions[:price] <= 0
    properties = Property.where(query.compact.join(' AND '), conditions)
  end

end
