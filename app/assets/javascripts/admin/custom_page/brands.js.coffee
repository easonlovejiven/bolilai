$ ->
	$('.brands_top_list .link').each ->
		index = $(this).index()
		configuration = {
			name: '品牌（'+(index+1)+'）',
			fields: [
				{
					name: 'ID',
					route: ['brands', index, 'id'],
					callback: -> $('.brands_top_list .link:eq('+index+')').attr('href', '/auction/products?where[brand_id]='+this.value)
				},
				{
					name: '图片',
					route: ['brands', index, 'pic'],
					update: {
						type: 'attr',
						name: 'src',
						selector: '.brands_top_list .link:eq('+index+') .pic'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
