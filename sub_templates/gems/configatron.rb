gem 'configatron'

run 'bundle install'

initializer 'configatron.rb', <<-FILE
Configatron::Rails.init
FILE

FileUtils.mkdir_p('config/configatron')
[:defaults, :development, :test, :staging, :production].each do |env|
  File.open("config/configatron/#{env}.rb", 'w')
end

File.open('config/configatron/defaults.rb', 'w') do |file|
  file.write <<-FILE
# site:
configatron.site.host = 'www.#{@app_name}.com'
configatron.site.ssl.enabled = true
configatron.site.ssl.protocol = 'https'

# email:
configatron.email.defaults.from = 'donotreply@#{app_name}.com'
configatron.email.allowable_domains = [/^.+@#{app_name}.com$/, /^.+@markbates.com$/]

# pagination:
configatron.pagination.per_page = 20
FILE
end

File.open('config/configatron/production.rb', 'w') do |file|
  file.write <<-FILE
# site:
configatron.site.host = 'www.#{@app_name}.com'
configatron.site.ssl.enabled = true
configatron.site.ssl.protocol = 'https'
FILE
end

File.open('config/configatron/staging.rb', 'w') do |file|
  file.write <<-FILE
# site:
configatron.site.host = '#{@app_name}-staging.heroku.com'
configatron.site.ssl.enabled = true
configatron.site.ssl.protocol = 'https'
FILE
end

File.open('config/configatron/development.rb', 'w') do |file|
  file.write <<-FILE
# site:
configatron.site.host = 'localhost:3000'
configatron.site.ssl.enabled = false
configatron.site.ssl.protocol = 'http'
FILE
end

File.open('config/configatron/test.rb', 'w') do |file|
  file.write <<-FILE
# site:
configatron.site.ssl.enabled = true

# email:
configatron.email.allowable_domains = [/^.+$/]
FILE
end