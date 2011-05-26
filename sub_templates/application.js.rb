File.open('app/assets/javascripts/ajax.js.coffee', 'w') do |f|
  f.write <<-FILE
$ ->
  
  $('#loading').ajaxStart ->
    $(this).show()

  $('#loading').ajaxSuccess (e, xhr, settings) ->
    $(this).hide()
    Util.timeago()

  $('#loading').ajaxError (e, xhr, settings, exception) ->
    $(this).hide()
  
FILE
end

File.open('app/assets/javascripts/utilities.js.coffee', 'w') do |f|
  f.write <<-FILE
window.Util = class Utilities

  @setFlashMessage: (name, msg) ->
    $("#flash_\#{name}").remove()
    $('#flash_messages').append("<div id='flash_\#{name}' class='flash flash_\#{name}' data-fadeout='7000'>\#{msg}</div>")
    @setFadeOuts()
    
  @setFadeOuts: ->
    $('[data-fadeout]').each ->
      $(this).delay($(this).attr('data-fadeout')).fadeOut()
      
  @setActiveInputs: ->
    target = $('input[type!=submit], textarea')
    target.focus ->
      $(this).css('background-color', '#FFFCD5')
    target.blur ->
      $(this).css('background-color', '')
        
  @timeago: ->
    $("span.timeago").timeago()
FILE
end

File.open('app/assets/javascripts/page_load.js.coffee', 'w') do |f|
  f.write <<-FILE
$ ->

  Util.setFadeOuts()
  Util.setActiveInputs()
  Util.timeago()
  
FILE
end