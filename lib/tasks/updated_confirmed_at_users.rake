# rake updated_confirmed_at_users
task :updated_confirmed_at_users => :environment do
  User.all.each do |user|
    user.update(confirmed_at: DateTime.now)
  end
end
