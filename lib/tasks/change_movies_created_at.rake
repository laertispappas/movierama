require 'rake'
task :change_movies_created_at => :environment do
  day_ago = 1
  day_increment = 1

  puts "Changing movies creation. Start: #{day_ago}, increment: #{day_increment}"

  Movie.all.each do |movie|
    movie.created_at = day_ago.days.ago
    movie.save!
    day_ago += day_increment
  end
end