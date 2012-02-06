class Type < ActiveRecord::Base
  validates_presence_of :name
  
  mount_uploader :icon, IconUploader
end
