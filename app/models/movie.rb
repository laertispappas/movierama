class Movie < ActiveRecord::Base
  acts_as_votable
  belongs_to :user


  def self.sort_by(sort_type)
    case sort_type
      when 'likes'
        order(:cached_votes_up => :desc)
      when 'hates'
        order(:cached_votes_down => :desc)
      when 'date'
        order(:created_at => :desc)
      else
        order(:cached_votes_up => :desc)
    end
  end
end
