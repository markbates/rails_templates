File.open('config/database.yml', 'w') do |f|
  f.write <<-FILE
development:
  adapter: postgresql
  encoding: unicode
  database: #{@app_name}_development
  pool: 5
  username: postgres
  password: postgres

test:
  adapter: postgresql
  encoding: unicode
  database: #{@app_name}_test
  pool: 5
  username: postgres
  password: postgres
FILE
end

rake 'db:drop:all'
rake 'db:create:all'