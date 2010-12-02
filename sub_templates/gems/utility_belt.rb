inject_into_file('Gemfile', :after => "group(:development, :test) do\n") do
  <<-FILE
  gem 'utility_belt', :require => false, :git => 'git://github.com/markbates/utility-belt.git'
  FILE
end