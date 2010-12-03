gem 'yamler'

Dir.glob(File.join(File.dirname(__FILE__), 'gems', '*.rb')) do |f|
  apply(File.expand_path(f))
end

run 'bundle install'