$ ->
	$('.auction_pages_ultimate .ultimate_link').each ->
		index = $(this).closest('.section').index()
		configuration = {
			name: '链接（'+(index+1)+'）'
			fields: [
				{
					name: '地址'
					route: ['sections', index, 'url']
					updater: { type: 'attr', name: 'href', selector: '.auction_pages_ultimate .section:eq('+index+') .ultimate_link' }
				}
				{
					name: '图片'
					route: ['sections', index, 'image']
					updater: { type: 'attr', name: 'src', selector: '.auction_pages_ultimate .section:eq('+index+') .ultimate_link .image' }
				}
				{
					name: '文本'
					route: ['sections', index, 'text']
					updater: { type: 'text', selector: '.auction_pages_ultimate .section:eq('+index+') .ultimate_link' }
				}
				{
					name: '样式 背景颜色'
					route: ['sections', index, 'style', 'background-color']
					updater: { type: 'css', name: 'background-color', selector: '.auction_pages_ultimate .section:eq('+index+') .ultimate_link' }
				}
				{
					name: '样式 背景图片'
					route: ['sections', index, 'style', 'background-image']
					updater: { type: 'css', name: 'background-image', selector: '.auction_pages_ultimate .section:eq('+index+') .ultimate_link' }
				}
				{
					name: '样式 宽度'
					route: ['sections', index, 'style', 'width']
					updater: { type: 'css', name: 'width', selector: '.auction_pages_ultimate .section:eq('+index+') .ultimate_link' }
				}
				{
					name: '样式 高度'
					route: ['sections', index, 'style', 'height']
					updater: { type: 'css', name: 'height', selector: '.auction_pages_ultimate .section:eq('+index+') .ultimate_link' }
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.auction_pages_ultimate .products .item_mod').each ->
		index = $(this).closest('.section').index()
		index2 = $(this).closest('.js_product').index()
		configuration = {
			name: '产品（'+(index+1)+'）（'+(index2+1)+'）'
			fields: [
				{
					name: 'ID'
					route: ['sections', index, 'ids', index2]
					updater: ->
						$.ajax
							url: '/auction/products/'+this.value+'.json',
							context: $('.auction_pages_ultimate .section:eq('+index+') .item_mod:eq('+index2+')')
							success: (data) ->
								$(this).attr('href', '/auction/products/'+data.product.id)
								$(this).find('.img').attr('src', data.product.major_pic+'.thumb145.jpg')
								$(this).find('.del').text(data.product.discount)
								$(this).find('.current').text(data.product.price)
								$(this).find('.summary').html('<span>'+h(data.product.brand.name)+'</span>'+h(data.product.name.replace(data.product.brand.name, ''))+'')
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	# $('.auction_pages_ultimate .products').each ->
	# 	index = $(this).closest('.section').index()
	# 	configuration = {
	# 		name: '产品列表（'+(index+1)+'）'
	# 		fields: [
	# 			{
	# 				name: '个数'
	# 				route: ['sections', index, 'count']
	# 			}
	# 			{
	# 				name: '样式 背景颜色'
	# 				route: ['sections', index, 'style', 'background-color']
	# 				updater: { type: 'css', name: 'background-color', selector: '.auction_pages_ultimate .section:eq('+index+')' }
	# 			}
	# 			{
	# 				name: '样式 背景图片'
	# 				route: ['sections', index, 'style', 'background-image']
	# 				updater: { type: 'css', name: 'background-image', selector: '.auction_pages_ultimate .section:eq('+index+')' }
	# 			}
	# 		]
	# 	}
	# 	$(this).addClass('preview_link').data('configuration', configuration)
