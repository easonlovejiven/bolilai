#$ ->
#	$('.series_a3 .product_list .link').each ->
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
#							context: $('.series_a3 .product_list .link:eq('+index+')'),
#							success: (data) ->
#								$(this).attr('href', '/auction/products/'+data.product.id)
#								$(this).find('.summary span').text(data.product.brand.name)
#								$(this).find('.summary em').text(data.product.name.sub(data.product.brand.name, ""))
#								$(this).find('.MarketPrice span').text(data.product.price)
#								$(this).find('.WeimallPrice span').text(data.product.discount)
#				}
#				{
#					name: '标题',
#					route: ['products', index, 'title'],
#					update: {
#						type: 'text',
#						selector: '.series_a3 .product_list .link:eq('+index+') .title'
#					}
#				}
#				{
#					name: '图片',
#					route: ['products', index, 'pic'],
#					update: {
#						type: 'attr',
#						name: 'src',
#						selector: '.series_a3 .product_list .link:eq('+index+') .pic img'
#					}
#				}
#			]
#		}
#		$(this).addClass('preview_link').data('configuration', configuration)
