gem 'yamler'

if ENV['all'] || yes?("Do you want to use Heroku?")
  gsub_file('config/environments/production.rb', 'config.serve_static_assets = false', 'config.serve_static_assets = true')
  
  append_to_file('Gemfile') do
<<-FILE
group(:staging, :production) do
  gem 'therubyracer-heroku', '>=0.8.1.pre3'
end
FILE
  end
  
  
  inject_into_file('Gemfile', :after => "group(:development, :test) do\n") do
<<-FILE
  gem 'heroku'
  gem 'taps'
FILE
  end

  run 'bundle install'

  file 'config/heroku.yml', <<-FILE
defaults: &default
  deploy_branch: master
  stack: bamboo-mri-1.9.2

production:
  <<: *default
  app_name: #{@app_name}-production

staging:
  <<: *default
  app_name: #{@app_name}-staging
FILE

  file 'lib/tasks/heroku.rake', <<-FILE
module Heroku

  class << self
  
    attr_accessor :env
    attr_accessor :app_name
    attr_accessor :deploy_branch
    attr_accessor :stack
  
    def configuration!
      unless @configuration
        require 'yamler'
        config = Yamler.load(File.join(File.dirname(__FILE__), '..', '..', 'config', 'heroku.yml'))
        @configuration = config[Heroku.env]
        @configuration.each do |k, v|
          Heroku.send("\#{k}=", v)
        end
      end
      return @configuration
    end
  
    def execute(cmd)
      cmd = "heroku \#{cmd} --app \#{Heroku.app_name}"
      Heroku.command(cmd)
      system "heroku restart --app \#{Heroku.app_name}"
    end
  
    def command(cmd)
      puts "#--> \#{cmd} <--#"
      system cmd
    end
  
  end

end

namespace :heroku do

  task :create, :env do |t, args|
    @env = args[:env] || 'staging'
    Heroku.env = @env
    Heroku.configuration!
  
    Heroku.execute "create \#{Heroku.app_name} --stack \#{Heroku.stack}"
    File.open(File.join(File.dirname(__FILE__), '..', '..', '.git', 'config'), 'a') do |f|
      f.write <<-EOF
[remote "heroku-\#{Heroku.env}"]
	url = git@heroku.com:\#{Heroku.app_name}.git
	fetch = +refs/heads/*:refs/remotes/heroku-\#{Heroku.env}/*
EOF
    end
    Rake::Task['heroku:setup'].invoke
    Rake::Task['heroku:deploy'].invoke
  end

  task :setup, :env do |t, args|
    unless @env
      @env = args[:env] || 'staging'
      puts "@env: \#{@env}"
      Heroku.env = @env
      Heroku.configuration!
    end
  
    Heroku.execute "config:add RACK_ENV=\#{@env}"
    Heroku.execute "config:add BUNDLE_WITHOUT=development:test"
  
    # %w{HOPTOAD_KEY S3_KEY S3_SECRET}.each do |key|
    #   Heroku.execute "config:add \#{key}=\#{ENV[key]}" unless ENV[key].nil? || ENV[key] == ''
    # end
    Heroku.execute 'config'
    Heroku.execute 'addons:add custom_domains:basic'
    Heroku.execute 'addons:add newrelic:bronze'
    Heroku.execute 'addons:add sendgrid:free'
    Heroku.execute 'addons:add ssl:piggyback'
    Heroku.execute 'addons:add zerigo_dns:basic'
  end

  task :deploy, :env do |t, args|
    @env = args[:env] || 'staging'
    Heroku.env = @env
    Heroku.configuration!
  
    Heroku.command "git checkout \#{Heroku.deploy_branch}"
    # Heroku.execute "stack:migrate \#{Heroku.stack}"
    Heroku.command "git push heroku-\#{@env} \#{Heroku.deploy_branch}:master --force"
    Heroku.execute "rake db:migrate"
    # Heroku.execute "rake sunspot:solr:reindex"
    Heroku.execute "rake hoptoad:deploy TO=\#{@env}"
  end

end

task :heroku => ['heroku:deploy']
FILE
end