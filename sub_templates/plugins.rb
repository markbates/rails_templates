plugin('ssl_requirement', :git => 'http://github.com/bartt/ssl_requirement.git')
plugin('annotate_models', :git => 'http://github.com/markbates/annotate_models.git')

inject_into_file('app/controllers/application_controller.rb', "  include SslRequirement\n", :after => "class ApplicationController < ActionController::Base\n")

inject_into_file('app/controllers/application_controller.rb', :after => "protected\n") do
<<-FILE
  def ssl_allowed_with_local?
    if configatron.site.ssl.enabled
      return ssl_allowed_without_local?
    end
    return true
  end

  alias_method_chain :ssl_allowed?, :local

FILE
end

inject_into_file('spec/controllers/application_controller_spec.rb', :after => "render_views\n") do
<<-FILE

  describe 'ssl_allowed_with_local?' do
  
    it 'should return the value ofssl_allowed_without_local?' do
      @controller.stub!(:ssl_allowed_without_local?).and_return(false)
      @controller.send(:ssl_allowed_with_local?).should be_false
    end
  
    it 'should return true if ssl isnt enabled' do
      configatron.temp do
        configatron.site.ssl.enabled = false
        @controller.send(:ssl_allowed_with_local?).should be_true
      end
    end
  
  end

FILE
end