file '.rvmrc', <<-FILE
rvm use 1.9.2@#{@app_name}
FILE

run "rvm use 1.9.2@#{@app_name}"
run "gem install bundler"