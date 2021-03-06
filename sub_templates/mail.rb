generate(:mailer, 'Postman')

gsub_file('app/mailers/postman.rb', 'default from: "from@example.com"', 'default :from => configatron.email.defaults.from')

inject_into_file('config/application.rb', :after => "class Application < Rails::Application\n") do
<<-FILE

    config.action_mailer.default_url_options = {:host => configatron.site.host}

FILE
end

initializer 'mail.rb', <<-FILE
# We need to load ActionMailer to be able to extend it:
ActionMailer::Base

# Delayed::Job needs to load the ActionMailers:
Postman

#  Prevent emails to outside addresses:
module Mail
  class Message
    
    def deliver_with_concern
      if ActionMailer::Base.delivery_method == :test
        deliver_without_concern
      else
        valid = true
        [self.to].flatten.each do |address|
          configatron.email.allowable_domains.each do |pattern|
            valid = address.match(pattern) unless address.nil?
            break if valid
          end
          break unless valid
        end
        if valid
          deliver_without_concern
        end
        puts self.to_s
      end
    end
    
    alias_method_chain :deliver, :concern
    
  end # Message
end # Mail
FILE