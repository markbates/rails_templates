gem "hoptoad_notifier"

run 'bundle install'

generate('hoptoad', "--api-key #{ENV['HOPTOAD_KEY']}")

File.open('config/initializers/hoptoad.rb', 'w') do |f|
  f.write <<-FILE
HoptoadNotifier.configure do |config|
  config.api_key = '#{ENV['HOPTOAD_KEY']}'
  config.host = 'www.fluxtracker.com'
  config.secure = true
end
FILE
end