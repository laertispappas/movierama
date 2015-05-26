class Movie < ActiveRecord::Base
  ratyrate_rateable 'rate'

  include PgSearch
  acts_as_votable

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :title
  validates_presence_of :description
  validates :user, presence: true

  pg_search_scope :full_search, :against => { :title => 'A', :description => 'B' },
                  using: { tsearch: { any_word: true, prefix: true, dictionary: 'english' } }



  # sort by column. We axcept only likes hates and date as input from parameters
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

  # need to reorder for search results from pg_search
  def self.sort_search_results(column, direction)
    case column
      when 'likes'
        reorder(:cached_votes_up => direction)
      when 'hates'
        reorder(:cached_votes_down => direction)
      when 'date'
        reorder(:created_at => direction)
      else
        reorder(:cached_votes_up => direction)
    end
  end
end
