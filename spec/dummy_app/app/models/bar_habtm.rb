class BarHabtm < ActiveRecord::Base
  has_and_belongs_to_many :foo_habtms
  has_object_diff_trail
end
