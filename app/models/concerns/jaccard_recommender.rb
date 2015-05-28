# Recommendation engine using Jaccard similarity to find similar movies a user might like (prototyping purposes).
# TODO need to implement recommendation as a background job probably using redis (for its data stractures and because it is very fast)
# TODO implement it using recommendify gem (collaborative filtering): https://github.com/paulasmuth/recommendify

module JaccardRecommender extend ActiveSupport::Concern

  def recommendation_for(movie)
    movies_scores = []

    Movie.all.collect{|m| movies_scores << self.prediction_for(m) unless m == movie }
    movies_scores.map! do |m, s|
      s = -1 if s.nan?
      [m, s]
    end

    # sorts similarity array and get the first top 5 movies. Similarity: [-1, 1].
    movies_scores.sort_by!{ |movie, sim| sim }.reject!{ |movie, sim| (sim < 0.3) }.map!{ |movie, sim| movie } unless movies_scores.empty?
    movies_scores[1..5]
  end

  def similarity_with(user)
    my_likes = self.votes.where(vote_flag: true).pluck(:votable_id)
    my_hates = self.votes.where(vote_flag: false).pluck(:votable_id)
    user_likes = user.votes.where(vote_flag: true).pluck(:votable_id)
    user_hates = user.votes.where(vote_flag: false).pluck(:votable_id)

    agreements = (my_likes & user_likes).size
    agreements += (my_hates & user_hates).size

    disagreements = (my_likes & user_hates).size
    disagreements += (my_hates & user_likes).size

    total = (my_likes + my_hates) | (user_likes + user_hates)

    return (agreements - disagreements) / total.size.to_f
  end

  def prediction_for(item)
    hive_mind_sum = 0.0
    item_total_likes = item.get_up_votes.size
    item_total_hates = item.get_down_votes.size

    rated_by = item_total_likes + item_total_hates

    item.get_up_votes.map do |v|
      u = User.find(v.voter_id)
      if u != self
        hive_mind_sum += self.similarity_with(u)
      end
    end

    item.get_down_votes.map do |v|
      u = User.find(v.voter_id)
      if u != self
        hive_mind_sum -= self.similarity_with(u)
      end
    end

    result =  hive_mind_sum / rated_by.to_f
    return [item.id, result]
  end
end