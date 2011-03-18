run "bundle install"

File.open('config/database.yml', 'w') do |f|
  f.write <<-FILE
development: &default
  adapter: postgresql
  encoding: unicode
  database: #{@app_name}_development
  pool: 5
  username: postgres
  password: postgres
  min_messages: warning

test:
  <<: *default
  database: #{@app_name}_test
FILE
end

rake 'db:drop:all'
rake 'db:create:all'