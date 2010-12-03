ns = "#{@app_name}_#{rand(9999999)}"
file '.rvmrc', <<-FILE
rvm use 1.9.2@#{ns}
FILE

run "rvm use 1.9.2@#{ns}"
run "gem install bundler"