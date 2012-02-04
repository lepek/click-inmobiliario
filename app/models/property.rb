class Property < ActiveRecord::Base
  
  belongs_to :location
  belongs_to :type
  belongs_to :currency
  belongs_to :operation
  
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
  
  
  def full_address
    [address, location.name, 'Argentina'].compact.join(', ')
  end

  def self.search(conditions)
    properties = Property.where(
        'location_id = ? AND type_id = ? AND operation_id = ? AND currency_id = ?',
        conditions[:location_id],
        conditions[:type_id],
        conditions[:operation_id],
        conditions[:currency_id]
    )
    if conditions[:price] > 0
      properties = properties.where('price < ?', conditions[:price])
    end
  end
  
end
