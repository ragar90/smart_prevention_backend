class Position < ActiveRecord::Base
	scope :last_positions, ->{where("created_at > ?", 24.hours.ago )}
	belongs_to :user
end