class Photo < ActiveRecord::Base
  
   attr_accessible :description, :file

   belongs_to :property

   mount_uploader :file, PhotoUploader
  
end
