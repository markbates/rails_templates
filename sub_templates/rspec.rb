append_to_file 'Gemfile', <<-FILE
group(:development, :test) do
  gem "rspec-rails", ">= 2.2.0"
  gem 'remarkable', '>= 4.0.0.alpha4', :require => false
  gem 'remarkable_activerecord', '>=4.0.0.alpha4'
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
require 'remarkable/core'
require 'remarkable/active_record'
FILE
end

inject_into_file('spec/spec_helper.rb', :after => "config.use_transactional_fixtures = true\n") do
<<-FILE

  config.global_fixtures = :all

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