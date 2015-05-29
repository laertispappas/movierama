class Movie < ActiveRecord::Base

  include PgSearch
  acts_as_votable

  include PublicActivity::Common
  include RedditRecommender # concern
  include Searchable  # concern

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :ratings, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { minimum: 20, maximum: 1000 }
  validates :user_id, presence: true
  validate :picture_size

  before_create :update_reddit_score # method from reddit_recommender

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

  # check if user has created this movie
  def created_by(user)
    self.user == user
  end

  private
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
