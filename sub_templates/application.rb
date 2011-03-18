inject_into_file('config/application.rb', :after => "# config.autoload_paths += %W(\#{config.root}/extras)\n") do
<<-FILE
    config.autoload_paths << File.join(Rails.root, 'lib')
FILE
end

gsub_file('config/application.rb', 'config.filter_parameters += [:password]', 'config.filter_parameters += [:password, :password_confirmation]')

inject_into_file('config/application.rb', :after => "class Application < Rails::Application\n") do
<<-FILE

    config.generators do |g|
    end

FILE
end

inject_into_file('config/environments/development.rb', :after => "::Application.configure do\n") do
<<-FILE
  config.log_level = :info
FILE
end