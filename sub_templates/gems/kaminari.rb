gem 'kaminari'

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

initializer 'pagination.rb', <<-FILE
class ActiveRecord::Base
  
  def self.paginate(options = {})
    page(options[:page] || 1).per(options[:per_page] || 20)
  end
  
end
FILE

inject_into_file('app/helpers/application_helper.rb', :after => "module ApplicationHelper\n") do
<<-FILE
  def page_entries_info(collection)
    # Displaying posts 6 - 10 of 26 in total
    return '' if collection.total_count == 0
    from = collection.offset_value + 1
    to = collection.offset_value + collection.limit_value
    to = collection.total_count if to > collection.total_count
    name = collection.first.class.name.downcase
    if (to - (from - 1)) != 1
      name = name.pluralize
    end
    html = "Displaying \#{name} \#{from} - \#{to} of \#{collection.total_count} in total"
    content_tag(:div, html, :class => 'page_entries_info')
  end
FILE
end

inject_into_file('spec/helpers/application_helper_spec.rb', :after => "describe ApplicationHelper do\n") do
<<-FILE

  describe "page_entries_info" do
  
    before(:each) do
      @collection = [users(:mark)]
      @collection.stub!(:total_count).and_return(26)
      @collection.stub!(:limit_value).and_return(10)
      @collection.stub!(:offset_value).and_return(0)
    end
  
    it "should handle empty collections" do
      @collection.stub!(:total_count).and_return(0)
      html = helper.page_entries_info(@collection)
      html.should == ''
    end
  
    it "should handle first page" do
      html = helper.page_entries_info(@collection)
      html.should == "<div class=\\"page_entries_info\\">Displaying users 1 - 10 of 26 in total</div>"
    end
  
    it "should handle middle page" do
      @collection.stub!(:offset_value).and_return(10)
      html = helper.page_entries_info(@collection)
      html.should == "<div class=\\"page_entries_info\\">Displaying users 11 - 20 of 26 in total</div>"
    end
  
    it "should handle last page" do
      @collection.stub!(:offset_value).and_return(20)
      html = helper.page_entries_info(@collection)
      html.should == "<div class=\\"page_entries_info\\">Displaying users 21 - 26 of 26 in total</div>"
    end
  
  end
  
FILE
end