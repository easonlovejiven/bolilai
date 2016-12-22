$ ->
	$('.series_a6 .textbox .title').each ->
		configuration = {
		name: '名称',
		fields: [
			{
				name: '名称',
				route: ['title'],
				update: {
					type: 'text',
					selector: '.series_a6 .textbox .title'
				}
			}
		]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.series_a6 .textbox .description').each ->
		configuration = {
		name: '摘要',
		fields: [
			{
				name: '摘要',
				route: ['summary'],
				update: {
					type: 'text',
					selector: '.series_a6 .textbox .description'
				}
			}
		]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.series_a6 .leftpic').each ->
		configuration = {
			name: '大图',
			fields: [
				{
					name: '名称',
					route: ['link', 'name'],
					update: {
						type: 'attr',
						name: 'title',
						selector: '.series_a6 .leftpic'
					}
				}
				{
					name: '地址',
					route: ['link', 'url'],
					update: {
						type: 'attr',
						name: 'href',
						selector: '.series_a6 .leftpic'
					}
				}
				{
					name: '图片',
					route: ['link', 'pic'],
					update: {
						type: 'attr',
						name: 'src',
						selector: '.series_a6 .leftpic .pic'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.series_a6 .product_top .link').each ->
		configuration = {
			name: '产品',
			fields: [
				{
				name: 'ID',
				route: ['product', 'id'],
				callback: ->
					$.ajax
						url: '/auction/products/'+this.value+'.json',
						context: $('.series_a6 .product_top .link'),
						success: (data) ->
							$(this).attr('href', '/auction/products/'+data.product.id)
							$(this).find('.pic').attr('src', data.product.major_pic+'.promote.jpg')
							$(this).find('.summary span').text(data.product.brand.name)
							$(this).find('.summary em').text(data.product.name.sub(data.product.brand.name, ""))
							$(this).find('.MarketPrice span').text(data.product.price)
							$(this).find('.WeimallPrice span').text(data.product.discount)
							$(this).find('.preferential').html('直降<em>￥</em>'+(data.product.price-data.product.discount))
				}
				{
					name: '标题',
					route: ['product', 'title'],
					update: {
						type: 'text',
						selector: '.series_a6 .product_top .link .linktext .title'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.series_a6 .product_mod .product_list .link').each ->
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
						context: $('.series_a6 .product_mod .product_list .link:eq('+index+')'),
						success: (data) ->
							$(this).attr('href', '/auction/products/'+data.product.id)
							$(this).find('.pic').attr('src', data.product.major_pic+'.promote.jpg')
							$(this).find('.summary span').text(data.product.brand.name)
							$(this).find('.summary em').text(data.product.name.sub(data.product.brand.name, ""))
							$(this).find('.MarketPrice span').text(data.product.price)
							$(this).find('.WeimallPrice span').text(data.product.discount)
							$(this).find('.preferential').html('直降<em>￥</em>'+(data.product.price-data.product.discount))
				}
				{
					name: '标题',
					route: ['products', index, 'title'],
					update: {
						type: 'text',
						selector: '.series_a6 .product_mod .product_list .link:eq('+index+') .title'
					}
				}
				{
					name: '标签',
					route: ['products', index, 'label'],
					update: {
						type: 'text',
						selector: '.series_a6 .product_mod .product_list .link:eq('+index+') .label'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.series_a6 .morelink').each ->
		configuration = {
			name: '更多',
			fields: [
				{
					name: '地址',
					route: ['more'],
					update: {
						type: 'attr',
						name: 'href',
						selector: '.series_a6 .morelink'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)