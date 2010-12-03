inject_into_file('app/controllers/application_controller.rb', :after => "protect_from_forgery\n") do
<<-FILE

  layout :check_for_overlay

  helper :all

  rescue_from(ActiveRecord::RecordNotFound, :with => :send_to_404)

  protected
  def default_layout
    'application'
  end

  def check_for_overlay
    params[:overlay].blank? ? self.default_layout : false
  end

  def send_to_404
    render :file => 'public/404.html', :status => 404, :layout => false
  end

FILE
end

file 'spec/controllers/application_controller_spec.rb', <<-FILE
require 'spec_helper'

describe ApplicationController do
  render_views
  
  describe 'send_to_404' do
    
    it 'should rescue from an AR::NotFound error' do
      @controller.should_receive(:render).with(:file => 'public/404.html', :status => 404, :layout => false)
      @controller.send(:send_to_404)
    end
    
  end
  
  describe "default_layout" do
    
    it "should return the default layout'" do
      @controller.send(:default_layout).should == 'application'
    end
    
  end
  
  describe "check_for_overlay" do
    
    it "should return false if there's an overplay" do
      @controller.send(:check_for_overlay).should == 'application'
      @controller.stub!(:params).and_return(:overlay => true)
      @controller.send(:check_for_overlay).should == false
    end
    
  end
  
end
FILE