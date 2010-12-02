inject_into_file('Gemfile', :after => "group(:development, :test) do\n") do
  <<-FILE
  gem 'kathy_lee'
  FILE
end

inject_into_file('spec/spec_helper.rb', :after => "require 'rspec/rails'\n") do
<<-FILE
require 'kathy_lee'
FILE
end

inject_into_file('spec/spec_helper.rb', :after => "Dir[Rails.root.join(\"spec/support/**/*.rb\")].each {|f| require f}\n") do
<<-FILE

Dir[Rails.root.join("spec/factories/**/*.rb")].each {|f| require f}

FILE
end

inject_into_file('config/application.rb', :after => "g.test_framework :rspec\n") do
<<-FILE
      g.fixture_replacement :kathy_lee
FILE
end

append_to_file 'db/seeds.rb', <<-FILE
require 'kathy_lee'
Dir[Rails.root.join("spec/factories/**/*.rb")].each {|f| require f}
FILE