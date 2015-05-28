class AddRedditScoreToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :reddit_score, :string, default: ""
  end
end
