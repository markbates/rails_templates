append_to_file 'Gemfile', <<-FILE
group(:development, :test) do

end
FILE

gem 'yamler'

apply('rspec.rb') # run before other gems to ensure they can add to the spec_helper.rb file.

Dir.glob(File.join(File.dirname(__FILE__), 'gems', '*.rb')) do |f|
  apply(File.expand_path(f))
end

run 'bundle install'