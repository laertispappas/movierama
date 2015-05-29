class Rating < ActiveRecord::Base
  belongs_to :movie
  belongs_to :user

  validates :score, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5 }
  validates_presence_of :user
  validates_presence_of :movie

  # rate only once for a particularly movie
  validates_uniqueness_of :user, scope: :movie
end
