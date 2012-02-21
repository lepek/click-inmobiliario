class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :trackable,
    :timeoutable, :token_authenticatable, :encryptable, :encryptor => :sha512

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :role_id, :real_estate_id
  cattr_accessor :current_user
  
  belongs_to :role
  belongs_to :real_estate
  
  has_many :favorites
  has_many :properties, :through => :favorites
  
  validates_uniqueness_of :email
  validates_presence_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :password
  
end
