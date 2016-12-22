#$ ->
#	$('.series_a2 .pic_detail').each ->
#		configuration = {
#			name: '大图',
#			fields: [
#				{
#					name: '名称',
#					route: ['link', 'name'],
#					update: {
#						type: 'attr',
#						name: 'title',
#						selector: '.series_a2 .pic_detail'
#					}
#				}
#				{
#					name: '地址',
#					route: ['link', 'url'],
#					update: {
#						type: 'attr',
#						name: 'href',
#						selector: '.series_a2 .pic_detail'
#					}
#				}
#				{
#					name: '图片',
#					route: ['link', 'pic'],
#					update: {
#						type: 'attr',
#						name: 'src',
#						selector: '.series_a2 .pic_detail .pic'
#					}
#				}
#			]
#		}
#		$(this).addClass('preview_link').data('configuration', configuration)
#	$('.series_a2 .rightlink').each ->
#		configuration = {
#			name: '产品',
#			fields: [
#				{
#					name: 'ID',
#					route: ['product', 'id'],
#					callback: ->
#						$.ajax
#							url: '/auction/products/'+this.value+'.json',
#							context: $('.series_a2 .rightlink'),
#							success: (data) ->
#								$(this).attr('href', '/auction/products/'+data.product.id)
#								$(this).find('.pic_title').attr('src', data.product.major_pic+'.promote.jpg')
#								$(this).find('.summary span').text(data.product.brand.name)
#								$(this).find('.summary em').text(data.product.name.sub(data.product.brand.name, ""))
#								$(this).find('.MarketPrice span').text(data.product.price)
#								$(this).find('.WeimallPrice span').text(data.product.discount)
#				}
#				{
#					name: '标题',
#					route: ['product', 'title'],
#					update: {
#						type: 'text',
#						selector: '.series_a2 .product_info .textbox .title'
#					}
#				}
#				{
#					name: '摘要',
#					route: ['product', 'summary'],
#					update: {
#						type: 'text',
#						selector: '.series_a2 .product_info .textbox .description'
#					}
#				}
#			]
#		}
#		$(this).addClass('preview_link').data('configuration', configuration)
