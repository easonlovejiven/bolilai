$ ->
	$('.series_brand .brand_box .link').each ->
		index = $(this).index()
		configuration = {
			name: '品牌（'+(index+1)+'）',
			fields: [
				{
					name: 'ID',
					route: ['brands', 'ids', index],
					callback: ->
						$.ajax
							url: '/auction/brands/'+this.value+'.json',
							context: $('.series_brand .brand_box .link:eq('+index+')'),
							success: (data) ->
								$(this).attr('href', '/auction/products?where[brand_id]='+data.brand.id)
								$(this).find('.pic').attr('src', data.brand.pic)
								$(this).find('.cnname').html(data.brand.name)
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.series_brand .morelink').each ->
		configuration = {
			name: '更多',
			fields: [
				{
					name: '地址',
					route: ['brands', 'more'],
					update: {
						type: 'attr',
						name: 'href',
						selector: '.series_brand .morelink'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)