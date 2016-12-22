$ ->
	$('.series_a7 .product_top .link').each ->
		index = $(this).index()
		configuration = {
			name: '产品（'+(index+1)+'）',
			fields: [
				{
				name: 'ID',
				route: ['products', index, 'id'],
				callback: ->
					$.ajax
						url: '/auction/products/'+this.value+'.json',
						context: $('.series_a7 .product_top .link:eq('+index+')'),
						success: (data) ->
							$(this).attr('href', '/index.html#subapp=productGrid&popup=singleProduct&productId='+data.product.id)
							$(this).find('.pic').attr('src', data.product.major_pic+'.promote.jpg')
							$(this).find('.summary span').text(data.product.brand.name)
							$(this).find('.summary em').text(data.product.name.sub(data.product.brand.name, ""))
							$(this).find('.MarketPrice span').text(data.product.price)
							$(this).find('.WeimallPrice span').text(data.product.discount)
				}
				{
					name: '标题',
					route: ['products', index, 'title'],
					update: {
						type: 'text',
						selector: '.series_a7 .product_top .link:eq('+index+') .title'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.series_a7 .product_mod .link').each ->
		index = $(this).index()
		configuration = {
			name: '产品（'+(index+3)+'）',
			fields: [
				{
				name: 'ID',
				route: ['products', index+2, 'id'],
				callback: ->
					$.ajax
						url: '/auction/products/'+this.value+'.json',
						context: $('.series_a7 .product_mod .link:eq('+index+')'),
						success: (data) ->
							$(this).attr('href', '/index.html#subapp=productGrid&popup=singleProduct&productId='+data.product.id)
							$(this).find('.pic').attr('src', data.product.major_pic+'.promote.jpg')
							$(this).find('.summary span').text(data.product.brand.name)
							$(this).find('.summary em').text(data.product.name.sub(data.product.brand.name, ""))
							$(this).find('.MarketPrice span').text(data.product.price)
							$(this).find('.WeimallPrice span').text(data.product.discount)
				}
				{
					name: '标题',
					route: ['products', index+2, 'title'],
					update: {
						type: 'text',
						selector: '.series_a7 .product_mod .link:eq('+index+') .title'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)