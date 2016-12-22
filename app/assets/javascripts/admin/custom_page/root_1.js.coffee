$ ->
  $('#wallnav .link')
  .mousedown ->
    $('#wallcont').animate({top: -($(this).index() * 266) / 2 + (if $(this).next().next().length then 0 else 110)})
    $(this).addClass('current').siblings().removeClass('current')
    $('#wallnav').data('index', $(this).index())
  .click -> false
  $('#wallnav .link')
  .mouseover ->
    $(this).siblings().removeClass('current') if $(this).hasClass('current')
  $('#wallnav')
  .mouseleave ->
    $(this).find('.link:eq(' + ($(this).data('index') || 0) + ')').addClass('current')
  $('#wall_prev')
  .mousedown ->
    $('#wallnav .link.current').prev().prev().mousedown()
  .click -> false
  $('#wall_next')
  .mousedown ->
    $('#wallnav .link.current').next().next().mousedown()
  .click -> false
  #门店切换
  $('.tab_a a').mouseenter ->
    $('.tab_a a').removeClass 'a_on'
    $(this).addClass 'a_on'
    tab_a = $(this).index()
    $('.tab_alist').hide()
    $(this).parent('.tab_a').siblings('.tab_alist').eq(tab_a).show()
    name = $(this).parent('.tab_a').siblings('.tab_alist').eq(tab_a).children('a').attr('name')
    #    shopMsg.expeshop = name
    #console.log(name);
    $('.tab_city_pic').children('div').hide()
    $('.tab_city_pic').children('#a_' + name).show()
    return
  $('.tab_alist a').mouseenter ->
    $(this).addClass 'a_on'
    $(this).siblings('a').removeClass 'a_on'
    name = $(this).attr('name')
    #    shopMsg.expeshop = name
    $('.tab_city_pic').children('div').hide()
    $('.tab_city_pic').children('#a_' + name).show()
    $('.indexw_12mendian_map').attr 'href', $(this).attr('data')
    return
