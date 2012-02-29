class Property < ActiveRecord::Base

  belongs_to :location
  belongs_to :type
  belongs_to :operation
  belongs_to :real_estate

  has_many :photos, :dependent => :destroy
  has_many :favorites
  has_many :users, :through => :favorites 

  accepts_nested_attributes_for :photos

  is_impressionable :counter_cache => true

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
  validates_presence_of :operation
  validates_presence_of :real_estate

  composed_of :price,
    :class_name => "Money",
    :mapping => [%w(price cents), %w(currency currency_as_string)],
    :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency || Money.default_currency) },
    :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }

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
    Property.where("#{query.compact.join(' AND ')} AND ( #{self.build_query_for_prices(conditions)} )", conditions)
  end

  def is_favorite?
    (!User.current_user.nil? and User.current_user.properties.exists?(self))
  end

  def nearest_poi(poi_type=nil)
    nearest_poi = Hash.new
    return nearest_poi if poi_type.nil? or (poi_type.class != PoiType and poi_type.class != String)
    poi_type = PoiType.find(:first, :conditions => [ "lower(name) = ? ", poi_type.downcase]) if poi_type.class == String
    return nearest_poi unless poi_type 
    pois = Poi.search({:location_id => self.location_id, :poi_type_id => poi_type.id})
    return nearest_poi if pois.empty?
    pois.each do |poi|
      begin
      destination = Gmaps4rails.destination({"from" => self.full_address.to_s, "to" => poi.full_address.to_s}, {"mode" => "WALKING"})
      if destination[0]["distance"]["value"] and (nearest_poi["value"].nil? or nearest_poi["value"] > destination[0]["distance"]["value"])
        nearest_poi = destination[0]["distance"]
        nearest_poi[:poi] = poi
      end
      rescue Exception => e
        next
      end  
    end
    nearest_poi
  end

  private

    def self.build_query_for_prices(conditions)
      unless conditions[:currency].blank? || conditions[:price] <= 0
        currencies = Currency.all
        price_query = []
        currencies.each do |currency|
          price_query << " ( currency = '#{currency.code}' AND price < #{Money.new(conditions[:price], conditions[:currency]).exchange_to(currency.code.to_sym).cents} ) "
        end
        price_query.compact.join(' OR ')
      else
        '1=1'
      end
    end

end
