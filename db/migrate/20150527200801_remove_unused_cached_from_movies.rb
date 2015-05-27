class RemoveUnusedCachedFromMovies < ActiveRecord::Migration

  def self.up
    remove_column :movies, :cached_votes_score
    remove_column :movies, :cached_weighted_score
    remove_column :movies, :cached_weighted_total
    remove_column :movies, :cached_weighted_average
  end

  def self.down
    add_column :movies, :cached_votes_score, :integer, :default => 0
    add_column :movies, :cached_weighted_score, :integer, :default => 0
    add_column :movies, :cached_weighted_total, :integer, :default => 0
    add_column :movies, :cached_weighted_average, :float, :default => 0.0
    add_index  :movies, :cached_votes_score
    add_index  :movies, :cached_weighted_score
    add_index  :movies, :cached_weighted_total
    add_index  :movies, :cached_weighted_average
  end
end
