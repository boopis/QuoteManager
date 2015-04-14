namespace :db do

  desc 'Reset database and seed the data'
  task :all => [:drop, :create, :migrate, :seed]
end
