class Favorite < ActiveRecord::Base
  belongs_to :property
  belongs_to :user
end