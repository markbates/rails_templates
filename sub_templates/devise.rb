if yes?("Do you want to use Devise?")
  
  gem 'devise'
  
  run "bundle install"
  
  generate('devise:install')
  
  gsub_file('config/initializers/devise.rb', 
            'config.mailer_sender = "please-change-me@config-initializers-devise.com"', 
            %{config.mailer_sender = configatron.email.defaults.from})
  
#   inject_into_file('config/initializers/devise.rb', :after => "# config.http_authenticatable = false\n") do
# <<-FILE
#   config.http_authenticatable = true
# FILE
#   end
  
  generate(:devise, 'User')
  
  migration_file = nil
  Dir[File.join('db', 'migrate', '**.rb')].each do |f|
    migration_file = File.expand_path(f) if f.match(/devise_create_users/)
  end
  
  if migration_file
    inject_into_file(migration_file, :after => "create_table(:users) do |t|\n") do
<<-FILE
      t.string :name, :null => false
      t.string :time_zone, :default => 'Eastern Time (US & Canada)'
      t.confirmable
      t.token_authenticatable
FILE
    end
    inject_into_file(migration_file, :after => "add_index :users, :reset_password_token, :unique => true\n") do
<<-FILE
    add_index :users, :confirmation_token,   :unique => true
FILE
    end
  else
    raise "Could not find a migration file for Devise Users!!!"
  end
  
  File.open('app/models/user.rb', 'w') do |f|
    f.write <<-FILE
class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable

  attr_accessible :email, :password, :password_confirmation, 
                  :remember_me, :name, :time_zone

  validates :name, :presence => true

  def time_zone
    self['time_zone'].blank? ? 'Eastern Time (US & Canada)' : self['time_zone']
  end

end
FILE
  end
  
  File.open('spec/models/user_spec.rb', 'w') do |f|
    f.write <<-FILE
require 'spec_helper'

describe User do

  describe "time_zone" do

    it "should default to EST" do
      user = User.new
      user['time_zone'] = nil
      user['time_zone'].should be_blank
      user.time_zone.should == 'Eastern Time (US & Canada)'
    end

  end

end
FILE
  end
  
  file 'spec/fixtures/users.yml', <<-FILE
mark:
  id: "1"
  name: "Mark Bates"
  email: mark@example.com
  time_zone: "Eastern Time (US & Canada)"
  encrypted_password: $2a$10$zw/zoCJNjFQTmf3LuOqHrOvipXMMmqvZvXOn7Mpvk7Q8ZTWmpX.VC
  reset_password_token: 
  remember_created_at: 
  sign_in_count: "1"
  current_sign_in_at: <%= Time.now %>
  last_sign_in_at: <%= Time.now %>
  current_sign_in_ip: 127.0.0.1
  last_sign_in_ip: 127.0.0.1
  confirmation_token: 
  confirmed_at: <%= Time.now %>
  confirmation_sent_at: <%= Time.now %>
  authentication_token: 
  created_at: <%= Time.now %>
  updated_at: <%= Time.now %>
FILE

  inject_into_file('spec/spec_helper.rb', :after => "RSpec.configure do |config|\n") do
<<-FILE

  config.include(Devise::TestHelpers, :type => :controller)

FILE
  end
  
  File.open('spec/factories/user_factories.rb', 'w') do |f|
    f.write <<-FILE
# Define attributes for User:
KathyLee.attributes(:user) do
  name fake(:name)
  email fake(:email)
  password 'password'
  password_confirmation 'password'
  time_zone 'Eastern Time (US & Canada)'
end

KathyLee.define(:user) do
  user = User.new(options)
  user
end
FILE
  end
  
  inject_into_file('spec/spec_helper.rb', :after => "config.before(:each) do\n") do
<<-FILE
    Time.zone = 'UTC'
FILE
  end

  inject_into_file('spec/spec_helper.rb', :after => "config.after(:each) do\n") do
<<-FILE
    Time.zone = 'UTC'
FILE
  end
  
  inject_into_file('app/controllers/application_controller.rb', :after => "protected\n") do
<<-FILE
  def set_time_zone
    if current_user
      Time.zone = current_user.time_zone if current_user
    end
  end

FILE
  end
  
  inject_into_file('spec/controllers/application_controller_spec.rb', :after => "render_views\n") do
<<-FILE

  describe 'set_time_zone' do
  
    it 'should set the time zone to the users' do
      Time.zone.name.should == 'UTC'
      user = users(:mark)
      user.time_zone = 'Eastern Time (US & Canada)'
      @controller.stub!(:current_user).and_return(user)
      @controller.send(:set_time_zone)
      Time.zone.name.should == 'Eastern Time (US & Canada)'
    end
  
    it 'should do nothing if there is no user' do
      @controller.stub!(:current_user).and_return(false)
      Time.zone.name.should == 'UTC'
      @controller.send(:set_time_zone)
      Time.zone.name.should == 'UTC'
    end
  
  end

FILE
  end
  
  inject_into_file('config/routes.rb', :after => "devise_for :users") do
<<-FILE
 do
    get "/signin", :to => "devise/sessions#new"
    get "/signout", :to => "devise/sessions#destroy"
    get '/signup', :to => 'devise/registrations#new'
    post '/signup', :to => 'devise/registrations#create'
    get '/account', :to => 'devise/registrations#edit'
    put '/account/update', :to => 'devise/registrations#update'
  end
FILE
  end
  
  rake 'db:migrate'
  
end