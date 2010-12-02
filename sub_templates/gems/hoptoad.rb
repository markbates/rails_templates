gem "hoptoad_notifier", '>=2.3.12'

run 'bundle install'

generate('hoptoad', "--api-key #{ENV['HOPTOAD_KEY']}")