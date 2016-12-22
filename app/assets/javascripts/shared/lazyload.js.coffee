#= require plugins/jquery.lazyload

$ ->
	$(".lazyload").lazyload()
	$(document).on 'reload', -> $(".lazyload").lazyload()
