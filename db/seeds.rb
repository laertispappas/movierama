
puts 'Creating sample user laertis.pappas@gmail.com'
User.create!(email: "laertis.pappas@gmail.com", fname: "laertis",lname: "pappas", password: 'pappaspappas', password_confirmation: 'pappaspappas')

#puts 'Creating 15 movies for user'
#count = 1
#User.all.each do |user|
#  15.times do |i|
#    Movie.create(title: count.to_s + '-' + Faker::Lorem.sentence(2), description: Faker::Lorem.paragraph(7), user: user)
#    count += 1
#  end
#end
