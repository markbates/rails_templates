inject_into_file('Gemfile', :after => "group(:development, :test) do\n") do
  <<-FILE
  gem 'thin'
  FILE
end