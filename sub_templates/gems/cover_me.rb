inject_into_file('Gemfile', :after => "group(:development, :test) do\n") do
  <<-FILE
  gem 'cover_me', '>= 1.0.0.rc6', :require => false
  FILE
end

run 'bundle install'

generate('cover_me:install')

prepend_to_file 'spec/spec_helper.rb', 
<<-FILE
require 'cover_me'

FILE