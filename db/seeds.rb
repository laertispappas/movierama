
puts 'Creating 10 sample users laertis.pappas[0-10]@gmail.com'
10.times do |i|
  User.create!(email: "laertis.pappas#{i}@gmail.com", fname: "laertis#{i}",lname: "pappas#{i}", password: 'pappaspappas', password_confirmation: 'pappaspappas')
end

puts 'Creating 5 movies for each user'
count = 1
User.all.each do |user|
  1.times do |i|
    Movie.create(title: count.to_s + Faker::Lorem.sentence(2), description: Faker::Lorem.paragraph(7), user: user)
    count += 1
  end
end
