get "http://timeago.yarp.com/jquery.timeago.js", "app/assets/javascripts/jquery.timeago.js"

inject_into_file('app/assets/javascripts/application.js', :before => "//= require_tree .") do
<<-FILE
//= require jquery.timeago
//= require utilities
FILE
end