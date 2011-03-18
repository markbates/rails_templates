gem "hoptoad_notifier"

run 'bundle install'

generate('hoptoad', "--api-key #{ENV['HOPTOAD_KEY']}")