#$ ->
#	$('.series_a4 .product_list .link').each ->
#		index = $(this).index()
#		configuration = {
#			name: '产品（'+(index+1)+'）',
#			fields: [
#				{
#					name: 'ID',
#					route: ['products', index, 'id'],
#					callback: ->
#						$.ajax
#							url: '/auction/products/'+this.value+'.json',
#							context: $('.series_a4 .product_list .link:eq('+index+')'),
#							success: (data) ->
#								$(this).attr('href', '/auction/products/'+data.product.id)
#								$(this).find('.pic').attr('src', data.product.major_pic+'.promote.jpg')
#								$(this).find('.summary span').text(data.product.brand.name)
#								$(this).find('.summary em').text(data.product.name.sub(data.product.brand.name, ""))
#								$(this).find('.MarketPrice span').text(data.product.price)
#								$(this).find('.WeimallPrice span').text(data.product.discount)
#								$(this).find('.preferential').html('直降<em>￥</em>'+(data.product.price-data.product.discount))
#				}
#				{
#					name: '标题',
#					route: ['products', index, 'title'],
#					update: {
#						type: 'text',
#						selector: '.series_a4 .product_list .link:eq('+index+') .title'
#					}
#				}
#			]
#		}
#		$(this).addClass('preview_link').data('configuration', configuration)
#	$('.series_a4 .morelink').each ->
#		configuration = {
#			name: '更多',
#			fields: [
#				{
#					name: '地址',
#					route: ['more'],
#					update: {
#						type: 'attr',
#						name: 'href',
#						selector: '.series_a4 .morelink'
#					}
#				}
#			]
#		}
#		$(this).addClass('preview_link').data('configuration', configuration)
