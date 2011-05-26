run "mv public/stylesheets/*.css app/assets/stylesheets"
run "mv public/javascripts/*.js app/assets/javascripts"

run "rm app/assets/stylesheets/formtastic_changes.css"

run "cp -rf #{File.join(File.dirname(__FILE__), 'stylesheets')} app/assets"