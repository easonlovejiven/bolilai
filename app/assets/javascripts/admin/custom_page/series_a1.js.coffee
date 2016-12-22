#$ ->
#	$('.series_a1 .large_list .link').each ->
#		index = $(this).index()
#		configuration = {
#			name: '大型产品（'+(index+1)+'）'
#			fields: [
#				{
#					name: 'ID'
#					route: ['products', 'large', index, 'id']
#					callback: ->
#						$.ajax
#							url: '/auction/products/'+this.value+'.json',
#							context: $('.series_a1 .large_list .link:eq('+index+')'),
#							success: (data) ->
#								$(this).attr('href', '/auction/products/'+data.product.id)
#								$(this).find('.pic').attr('src', data.product.major_pic+'.promote.jpg')
#								$(this).find('.summary span').text(data.product.brand.name)
#								$(this).find('.summary em').text(data.product.name.sub(data.product.brand.name, ""))
#								$(this).find('.MarketPrice span').text(data.product.price)
#								$(this).find('.WeimallPrice span').text(data.product.discount)
#				}
#				{
#					name: '标题'
#					route: ['products', 'large', index, 'title']
#					update: {
#						type: 'text'
#						selector: '.series_a1 .large_list .link:eq('+index+') .title'
#					}
#				}
#			]
#		}
#		$(this).addClass('preview_link').data('configuration', configuration)
#	$('.series_a1 .small_list .link').each ->
#		index = $(this).index()
#		configuration = {
#			name: '小型产品（'+(index+1)+'）'
#			fields: [
#				{
#					name: 'ID'
#					route: ['products', 'small', 'ids', index]
#					callback: ->
#						$.ajax
#							url: '/auction/products/'+this.value+'.json',
#							context: $('.series_a1 .small_list .link:eq('+index+')')
#							success: (data) ->
#								$(this).attr('href', '/auction/products/'+data.product.id)
#								$(this).find('.pic').attr('src', data.product.major_pic+'.l200.jpg')
#								$(this).find('.summary span').text(data.product.brand.name)
#								$(this).find('.summary em').text(data.product.name.sub(data.product.brand.name, ""))
#								$(this).find('.MarketPrice span').text(data.product.price)
#								$(this).find('.WeimallPrice span').text(data.product.discount)
#				}
#			]
#		}
#		$(this).addClass('preview_link').data('configuration', configuration)
