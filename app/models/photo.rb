class Photo < ActiveRecord::Base

  attr_protected

  belongs_to :property

  mount_uploader :file, PhotoUploader

end
