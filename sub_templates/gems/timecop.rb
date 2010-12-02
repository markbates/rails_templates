inject_into_file('Gemfile', :after => "group(:development, :test) do\n") do
  <<-FILE
  gem 'timecop'
  FILE
end

inject_into_file('spec/spec_helper.rb', :after => "require 'rspec/rails'\n") do
<<-FILE
require 'timecop'
FILE
end

inject_into_file('spec/spec_helper.rb', :after => "config.before(:each) do\n") do
<<-FILE
    Timecop.freeze(DateTime.now)
FILE
end

inject_into_file('spec/spec_helper.rb', :after => "config.after(:each) do\n") do
<<-FILE
    Timecop.return
FILE
end