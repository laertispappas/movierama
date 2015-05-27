class Rating < ActiveRecord::Base
  belongs_to :movie
  belongs_to :user


  # rate only once for a particularly movie
#  validates_uniqueness_of :user, scope: :movie
end
