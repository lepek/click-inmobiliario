class Role < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :permission_roles
  has_many :permissions, :through => :permission_roles

  def self.get_real_estate_role
    2 # From seed file
  end

end
