class Movie < ActiveRecord::Base
  acts_as_votable
  belongs_to :user

  validates_presence_of :title
  validates_presence_of :description

  def self.sort_by(column, direction)

    case column
      when 'likes'
        order(:cached_votes_up => direction)
      when 'hates'
        order(:cached_votes_down => direction)
      when 'date'
        order(:created_at => direction)
      else
        order(:cached_votes_up => direction)
    end
  end
end
