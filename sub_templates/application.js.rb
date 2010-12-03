File.open('public/javascripts/application.js', 'w') do |f|
  f.write <<-FILE
$(function() {

  $('#loading').ajaxStart(function() {
    $(this).show();
  });

  $('#loading').ajaxSuccess(function(e, xhr, settings) {
    $(this).hide();
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

  $('[data-secret=true]').hide();
  $('a[data-secret-id]').click(function(e) {
    e.preventDefault();
    var link = $(this);
    $('#' + link.attr('data-secret-id')).toggle();
    if (link.text() == 'show') {
      link.text('hide');
    } else {
      link.text('show');
    }
  });

  // Examples: 
  // <div class="simple_overlay" id="foobar_overlay">
  //   <!-- the external content is loaded inside this tag -->
  //   <div class="contentWrap">this is fubar</div>
  // </div>
  // 
  // <a href='/foo?no_layout=true' data-lightbox='remote' rel='#overlay'>foo</a>
  // <a href='/foo/bar?no_layout=true' data-lightbox='local' rel='#foobar_overlay'>foo/bar</a>
  $("a[data-lightbox]").each(function() {
    var link = $(this);
    if (link.attr('rel') == null || link.attr('rel') == '') {
      link.attr('rel', '#overlay')
    }

    var concat = '?';
    if (/\?/.test(link.attr('href'))) {
      concat = '&';
    }
    if (!(/overlay=true/).test(link.attr('href'))) {
      link.attr('href', link.attr('href') + concat + 'overlay=true');
    }

    var opts = {top:125, mask: '#332F3E'}

    // if set to false the window can only be closed by clicking on the close button.
    if (link.attr('data-lightbox-closeable')) {
      opts.closeOnEsc = link.attr('data-lightbox-closeable') != 'false';
      opts.closeOnClick = opts.closeOnEsc;
    }

    if (link.attr('data-lightbox') == 'remote') {
      opts.onBeforeLoad = function() {
        var wrap = this.getOverlay().find(".contentWrap");
        wrap.load(this.getTrigger().attr("href"));
      };
      opts.onClose = function() {
        var wrap = this.getOverlay().find(".contentWrap");
        wrap.html('Loading...');
      };
    }

    if (link.attr('data-lightbox-on-close')) {
      opts.onClose = function() {
        eval(link.attr('data-lightbox-on-close'));
      };
    }

    link.overlay(opts);
  });

  $app.setFadeOuts();
  $app.setActiveInputs();

});

var $app = {
  genericCancel:function(path) {
    if (confirm('Are you sure?')) {
      window.location.href = path;
    }
  },
  closeAllOverlays:function() {
    $("a[data-lightbox]").each(function() {
      $(this).overlay().close();
    });
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
    $('input, textarea').focus(function() {
      $(this).addClass('active_input');
    }).blur(function() {
      $(this).removeClass('active_input');
    });
  }
}
FILE
end