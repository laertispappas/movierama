require 'rake'

task :create_users => :environment do
  usernames = %w[laertis pappas natia john xristos alex orfeas lapis kostas sokratis]
  passwd = 'pappaspappas'

  puts "Creating 10 sample users"

  usernames.each do |name|
    u = User.new(email: name+'@allpolls.com', fname: name, lname: name, password: passwd, password_confirmation: passwd)
    u.confirmed_at = Time.now
    u.save!
  end
end