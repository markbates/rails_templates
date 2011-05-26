gem 'delayed_job', '2.1.1'#, :git => 'git://github.com/collectiveidea/delayed_job.git'
gem "dj_remixes"

file "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_delayed_jobs.rb", <<-FILE
class CreateDelayedJobs < ActiveRecord::Migration
  def self.up
    create_table :delayed_jobs, :force => true do |t|
      t.integer :priority, :default => 0
      t.integer :attempts, :default => 0
      t.text :handler
      t.text :last_error
      t.string :locked_by
      t.string :worker_class_name
      t.datetime :run_at
      t.datetime :locked_at
      t.datetime :failed_at
      t.datetime :started_at
      t.datetime :finished_at
      t.timestamps
    end

    add_index :delayed_jobs, :priority
    add_index :delayed_jobs, :worker_class_name
    add_index :delayed_jobs, :run_at
  end
  
  def self.down
    drop_table :delayed_jobs
  end
end
FILE

rake 'db:migrate'

inject_into_file('config/application.rb', :after => "config.autoload_paths << File.join(Rails.root, 'lib')\n") do
<<-FILE
    config.autoload_paths << File.join(Rails.root, 'lib', 'workers')
FILE
end

file 'lib/tasks/dj.rake', <<-FILE
namespace :dj do
  
  task :retry_jobs => [:environment] do
    DJ.where('last_error is not null').each do |job|
      job.attempts = 0
      job.run_at = Time.now
      job.save
    end
  end
  
end
FILE