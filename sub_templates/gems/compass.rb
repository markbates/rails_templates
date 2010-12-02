gem 'compass'

run 'bundle install'

run "compass init rails . --using blueprint/basic"

append_to_file 'config/initializers/compass.rb', <<-FILE

# http://lds.li/post/673242899/compass-with-rails-3-on-heroku
# Adapted from
# http://github.com/chriseppstein/compass/issues/issue/130
# and other posts.

# Create the dir
require 'fileutils'
FileUtils.mkdir_p(Rails.root.join("tmp", "stylesheets"))

Sass::Plugin.on_updating_stylesheet do |template, css|
  puts "Compiling \#{template} to \#{css}"
end

Rails.configuration.middleware.insert_before('Rack::Sendfile', 'Rack::Static',
                                             :urls => ['/stylesheets/compiled'],
                                             :root => "\#{Rails.root}/tmp")
FILE

file 'app/stylesheets/partials/_utils.scss', <<-FILE
@mixin reset-mp {
  padding: 0px;
  margin: 0px;
}
FILE

append_to_file 'app/stylesheets/screen.scss', '@import "partials/utils";'