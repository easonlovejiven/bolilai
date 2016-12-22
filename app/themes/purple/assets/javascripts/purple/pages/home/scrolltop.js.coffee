$ ->
  $(document).delegate '#layout_scrolltop', 'mousedown', ->
    if $.scrollTo then $('html,body').animate({scrollTop: 0}, 'slow')
  $(window).on 'scroll', ->
    return if $.browser.msie && $.browser.version <= 6 && Math.random() > 0.5
    $('#layout_scrolltop').css('visibility', if $(window).scrollTop() > 300 then 'visible' else 'hidden')
