gem 'will_paginate', '>=3.0.pre2'#, :git => 'git://github.com/mislav/will_paginate.git'

inject_into_file('app/controllers/application_controller.rb', :after => "protected\n") do
<<-FILE
  def per_page
    configatron.pagination.per_page
  end

  def pagination_options(options = {})
    options = {:page => params[:page], :per_page => self.per_page}.merge(options)
    options[:page] = 1 if options[:page].blank?
    options[:per_page] = self.per_page if options[:per_page].blank?
    return options
  end

FILE
end

inject_into_file('spec/controllers/application_controller_spec.rb', :after => "render_views\n") do
<<-FILE

  describe "pagination_options" do
  
    it "should return the basic options for pagination" do
      @controller.send(:pagination_options).should == {:page => 1, :per_page => 20}
    end
  
    it "should handle other variations" do
      @controller.send(:pagination_options, {:page => 10}).should == {:page => 10, :per_page => 20}
      @controller.send(:pagination_options, {:page => nil}).should == {:page => 1, :per_page => 20}
      @controller.send(:pagination_options, {:per_page => 100}).should == {:page => 1, :per_page => 100}
      @controller.send(:pagination_options, {:per_page => nil}).should == {:page => 1, :per_page => 20}
    end
  
  end

FILE
end