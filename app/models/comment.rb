class Comment < ActiveRecord::Base
  has_ancestry

  belongs_to :commentable, polymorphic: true
  belongs_to :user
  validates :content, presence: true
  validates :commentable_type, inclusion: { in: %w(Movie Comment) }

  validates_presence_of :user
  validates_presence_of :commentable_type
  validates_presence_of :commentable_id
end
