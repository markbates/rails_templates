inject_into_file('app/helpers/application_helper.rb', :after => "module ApplicationHelper\n") do
<<-FILE

  def set_js_flash_messages(flash)
    js = []
    flash.each do |name, msg|
      js << %{Util.setFlashMessage '\#{name}', '\#{j msg}'}
    end
    flash.clear
    return js.join("\\n").html_safe
  end

  def title(page_title)
    content_for(:title) { page_title.to_s }
    "<h1>\#{page_title}</h1>".html_safe
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args, &block)
    content_for(:head) { javascript_include_tag(*args) }
    content_for(:scripts, &block)
  end
  
  def timeago(time, options = {})
    options[:class] ||= "timeago"
    content_tag(:span, time.to_s, options.merge(:title => time.getutc.iso8601)) if time
  end

FILE
end

file 'spec/helpers/application_helper_spec.rb', <<-FILE
require 'spec_helper'

describe ApplicationHelper do
  
  describe "set_js_flash_messages" do
    
    it "should set flash messages using JS" do
      flash = {:notice => 'Good job!', :alert => "that's freakin' sweet!"}
      js = helper.set_js_flash_messages(flash)
      flash.should be_empty
      js.should == "Util.setFlashMessage 'notice', 'Good job!'\\nUtil.setFlashMessage 'alert', 'that\\\\'s freakin\\\\' sweet!'"
    end
    
  end
  
  describe "title" do
    
    it "set a title for the page" do
      helper.content_for?(:title).should be_false
      helper.title('my title')
      helper.content_for?(:title).should be_true
    end
    
  end
  
  describe "stylesheet" do
    
    it "should set some stylesheets" do
      helper.stylesheet('application')
    end
    
  end
  
  describe "javascript" do
    
    it "should set some javascript" do
      helper.javascript('foo') do
        "var 1;"
      end
    end
    
  end
  
  describe "timeago" do
    
    it "should return a tag of the time" do
      time = Time.now
      helper.timeago(time).should == "<span class=\\"timeago\\" title=\\"\#{time.getutc.iso8601}\\">\#{time.to_s}</span>"
    end
    
  end
  
end
FILE