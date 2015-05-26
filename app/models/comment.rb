class Comment < ActiveRecord::Base
  has_ancestry

  belongs_to :commentable, polymorphic: true
  belongs_to :user
  validates :content, presence: true
end
