gem 'fog' # needed for carrierwave
gem 'carrierwave'
gem 'rmagick'

inject_into_file('spec/spec_helper.rb', :after => "require 'rspec/rails'\n") do
<<-FILE
require 'carrierwave/test/matchers'
FILE
end

inject_into_file('spec/spec_helper.rb', :after => "RSpec.configure do |config|\n") do
<<-FILE

  config.include(CarrierWave::Test::Matchers)

FILE
end

inject_into_file('spec/spec_helper.rb', :after => "config.after(:each) do\n") do
<<-FILE
    FileUtils.rm_rf(File.join(Rails.root, 'public', 'uploads'))
FILE
end