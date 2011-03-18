inject_into_file('Gemfile', :after => "group(:development, :test) do\n") do
<<-FILE
  gem 'database_cleaner'
  gem 'silent-postgres'
FILE
end

append_to_file 'db/seeds.rb', <<-FILE
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

FILE