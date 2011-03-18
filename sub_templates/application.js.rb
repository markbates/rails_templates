File.open('public/javascripts/application.js', 'w') do |f|
  f.write <<-FILE
$(function() {

  $('#loading').ajaxStart(function() {
    $(this).show();
  });

  $('#loading').ajaxSuccess(function(e, xhr, settings) {
    $(this).hide();
    $("span.timeago").timeago();
  });

  $('#loading').ajaxError(function(e, xhr, settings, exception) {
    $(this).hide();
  });

  $('input[data-cancel], a[data-cancel]').live('click', function(e) {
    e.preventDefault();
    eval($(this).attr('data-cancel'));
  });

  $('a[data-save]').live('click', function(e) {
    e.preventDefault();
    $(this).closest('form').submit();
  });

  $app.setFadeOuts();
  $app.setActiveInputs();

  $("span.timeago").timeago();

});

var $app = {
  genericCancel:function(path) {
    if (confirm('Are you sure?')) {
      window.location.href = path;
    }
  },
  setFlashMessage:function(name, msg) {
    $('#flash_' + name).remove();
    $('#flash_messages').append("<div id='flash_"+ name + "' class='flash flash_" + name +"' data-fadeout='5000'>" + msg + "</div>");
    $app.setFadeOuts();
  },
  setFadeOuts:function() {
    $('[data-fadeout]').each(function() {
      $(this).delay($(this).attr('data-fadeout')).fadeOut();
    });
  },
  setActiveInputs:function() {
    $('input[type!=submit], textarea').focus(function() {
      $(this).css('background-color', '#FFFCD5');
    }).blur(function() {
      $(this).css('background-color', '');
    });
  }
}
FILE
end