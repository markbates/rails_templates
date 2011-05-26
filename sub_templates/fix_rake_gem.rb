inject_into_file('Gemfile', :after => "source 'http://rubygems.org'\n") do
<<-FILE
gem 'rake', '0.8.7', :require => false
FILE
end