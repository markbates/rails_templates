inject_into_file('Gemfile', :after => "group(:development, :test) do\n") do
  <<-FILE
  gem 'fakeweb'
  FILE
end

inject_into_file('spec/spec_helper.rb', :after => "require 'rspec/rails'\n") do
<<-FILE
require 'fakeweb'
FILE
end

file 'spec/support/fakeweb.rb', <<-FILE
FakeWeb.allow_net_connect = %r[^https?://(localhost|127\.0\.0\.1)]

def fakeweb_file(name)
  File.read(File.join(File.dirname(__FILE__), 'fakeweb', name))
end
FILE
