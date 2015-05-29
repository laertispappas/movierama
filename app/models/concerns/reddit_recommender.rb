
# calculate movie rating base on Reddit algorithm
# Taken from https://github.com/reddit/reddit/blob/master/r2/r2/lib/db/_sorts.pyx
# Same as Jaccard similarity for prototyping purposes we do our calculation online!!! Not efficient!

module RedditRecommender extend ActiveSupport::Concern
  # Given time B: basetime
  # Given time A: time the movie was posted
  # we have ts as their difference in seconds
  # ts = A - B

  # x is the difference between upvotes U (likes) - Down votes D (hates)
  # x = U - D

  # where y in { -1, 0, 1 }
  # y = 1, if x > 0
  # y = 0, if x = 0
  # y = -1 if x < 0

  # and z as the maximal value of, of the absolute value of x and 1
  # z = |x|, if |x| >= 1
  # z = 1, if |x| < 1


  # we have the rating as the function: f(ts, y, z):
  # f(ts, y, z) = log10(z) + y*ts/45000

  included do
    $base_time = Time.new 2005, 12, 8, 7, 46, 43
  end

  # call this action to update movies score
  def update_reddit_score
    self.reddit_score = movie_score(self)
  end

  # return movies score based on reddit algorithm
  def movie_score(movie = self)
    movie_date = movie.created_at.to_datetime
    likes = movie.cached_votes_up
    hates = movie.cached_votes_down
    hot(likes, hates, movie_date)
  end

  # time difference between base date and date t: Ruby TIme object
  def time_difference(t)
    (t.to_i - $base_time.to_i).to_f
  end

  def hot(ups, downs, date)
    x = ups - downs
    y = 0

    if x > 0
      y = 1
    elsif x == 0
      y = 0
    else
      y = -1
    end

    ts = time_difference(date)
    z = [x.abs, 1].max

    return Math.log(z, 10)*y + (ts / 45000)
  end

  module ClassMethods
  end
end