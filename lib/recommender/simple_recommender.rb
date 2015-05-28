module SimpleRecommender

  # draft errors!!!
  def recommendations
    reco = Hash.new(0)
    # fetch my list of liked items (movies)
    my_movies = self.votes.pluck(:votable_id)
    similar_users_relation = User.all.map { |u| u.votes.where(votable_id: my_movies) }
    similar_user_ids = []
    similar_users_relation.each { |u| similar_user_ids << u.first.voter_id unless u.empty? }

    User.where(id: similar_user_ids).each do |user|
      user_movie_ids = user.votes.pluck(:votable_id)
      in_common = user_movie_ids & my_movies
      w = in_common.size.to_f / user_movie_ids.size

      # add the recommendation
      (user_movie_ids - in_common).each do |movie_id|
        reco[movie_id] = +w
      end
    end
    Movie.where(id: reco.keys).pluck(:id, :title).sort_by{ |a| reco[a]}
  end
end