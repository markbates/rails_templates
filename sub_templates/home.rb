generate(:controller, 'home', '--no-helper')

inject_into_file('config/routes.rb', :after => "Application.routes.draw do\n") do
<<-FILE

  root :to => "home#index"

FILE
end

file 'app/views/home/index.html.erb', <<-FILE
<%= title('Welcome!') %>
FILE

inject_into_file('spec/controllers/home_controller_spec.rb', :after => "describe HomeController do\n") do
<<-FILE
  render_views

  describe "index" do
  
    it "should render the home page" do
      get :index
    
      response.should render_template(:index)
    end
  
  end

FILE
end