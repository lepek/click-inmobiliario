class Property < ActiveRecord::Base
  
  belongs_to :location
  belongs_to :type
  belongs_to :currency
  belongs_to :operation
  
  acts_as_gmappable :process_geocoding => true, :check_process => false, :address => :full_address
  
  def full_address
    [address, location.name, 'Argentina'].compact.join(', ')
  end
  
end
