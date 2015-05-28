class Movie < ActiveRecord::Base

  include PgSearch
  acts_as_votable

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :ratings, dependent: :destroy

  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :description, presence: true, length: { minimum: 20, maximum: 1000 }
  validates :user_id, presence: true
  validate :picture_size

  pg_search_scope :full_search, :against => { :title => 'A', :description => 'B' },
                  using: { tsearch: { any_word: true, prefix: true, dictionary: 'english' } }

  mount_uploader :picture, PictureUploader



  def total_likes
    self.cached_votes_up
  end

  def total_hates
    self.cached_votes_down
  end

  def average_rating
    return ratings.sum(:score) if ratings.size == 0
    ratings.sum(:score) / ratings.size
  end

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

  private
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
