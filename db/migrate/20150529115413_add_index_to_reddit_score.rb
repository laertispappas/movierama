class AddIndexToRedditScore < ActiveRecord::Migration
  def change
    add_index :movies, :reddit_score
  end
end
