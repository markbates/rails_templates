append_to_file 'Gemfile', <<-FILE
group(:development, :test) do
  gem "rspec-rails", '>= 2.6.1.beta1'
  gem 'syntax'
  gem 'email_spec'
  gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git'
  gem 'launchy'
  gem 'hirb'
end
FILE

run 'bundle install'

generate('rspec:install')

prepend_to_file 'spec/spec_helper.rb', 
<<-FILE
ENV["RAILS_ASSET_ID"] = '1234567890' # set the asset to a constant # => "/images/missing/movies/poster_thumb.png?1234567890"

FILE

inject_into_file('spec/spec_helper.rb', :after => "require 'rspec/rails'\n") do
<<-FILE
require 'capybara/rspec'
require "email_spec"
FILE
end

inject_into_file('spec/spec_helper.rb', :after => "RSpec.configure do |config|\n") do
<<-FILE

  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)

FILE
end

inject_into_file('spec/spec_helper.rb', :after => "config.use_transactional_fixtures = true\n") do
<<-FILE

  config.global_fixtures = :all
  
  config.render_views
  
  config.before(:suite) do  
    DatabaseCleaner.strategy = :truncation  
  end

  config.before(:each) do
    DatabaseCleaner.start
    ActionMailer::Base.deliveries = []
  end

  config.after(:each) do
    ActionMailer::Base.deliveries = []
    DatabaseCleaner.clean
  end

FILE
end

inject_into_file('config/application.rb', :after => "config.generators do |g|\n") do
<<-FILE
      g.test_framework :rspec
FILE
end

gsub_file('spec/spec_helper.rb', 'config.use_transactional_fixtures = true', 'config.use_transactional_fixtures = false')