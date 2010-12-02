get "http://code.jquery.com/jquery-latest.min.js", "public/javascripts/jquery.js"
get "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.3/jquery-ui.min.js", "public/javascripts/jqueryui.js"
get "https://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"
get "http://cdn.jquerytools.org/1.2.5/all/jquery.tools.min.js", "public/javascripts/jquery.tools.min.js"

file 'public/javascripts/jquery.ie.live.patch.js', <<-FILE
/**
 * Patch (plugin) for jQuery bug 6359: "live('submit') does nothing in IE if
 * live('click') was called before. same with delegate."
 *
 * The workaround is to ensure that live('click') calls happen *after*
 * live('submit') calls. Fixing live() fixes delegate(), which calls live().
 *
 * This plugin uses setTimeout(..., 0) to effect the workaround. That is, it
 * defers live('click') calls to a future execution context. It should work
 * around the issue in most cases.
 *
 * @author Jonathan Aquino
 * @see http://dev.jquery.com/ticket/6359
 * @see TEZLA-538
 */
(function($) {
    var originalLive = jQuery.fn.live;
    jQuery.fn.live = function(types) {
        var self = this;
        var args = arguments;
        if (types == 'click') {
            setTimeout(function() {
                originalLive.apply(self, args);
            }, 0);
        } else {
            originalLive.apply(self, args);
        }
    };
})(jQuery);
FILE

append_to_file 'config/initializers/assets.rb', <<-FILE
ActionView::Helpers::AssetTagHelper.register_javascript_expansion :jquery => %w{jquery jquery.ie.live.patch jqueryui jquery.tools.min}
FILE