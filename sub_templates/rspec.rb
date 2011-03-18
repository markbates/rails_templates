append_to_file 'Gemfile', <<-FILE
group(:development, :test) do
  gem "rspec-rails"
  gem 'syntax'
  gem 'email_spec'
  gem 'capybara'
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

  config.before(:each) do
    ActionMailer::Base.deliveries = []
  end

  config.after(:each) do
    ActionMailer::Base.deliveries = []
  end

FILE
end

inject_into_file('config/application.rb', :after => "config.generators do |g|\n") do
<<-FILE
      g.test_framework :rspec
FILE
end