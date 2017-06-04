# describes branches model
class Branch < ApplicationRecord
  validates_presence_of :address
end
