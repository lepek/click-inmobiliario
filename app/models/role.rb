class Role < ActiveRecord::Base
  validates_uniqueness_of :name

  def self.get_real_estate_role
    2 # From seed file
  end

end
