$ ->
	$('.auction_pages_msn .box1 .link').each ->
		index = $(this).index()
		configuration = {
			name: '图片（'+(index+1)+'）'
			fields: [
				{
					name: '标题'
					route: ['images', index, 'title']
					updater: {
						type: 'text',
						selector: '.auction_pages_msn .box1 .link:eq('+index+') span'
					}
				}
				{
					name: '地址'
					route: ['images', index, 'url']
					updater: {
						type: 'attr'
						name: 'href'
						selector: '.auction_pages_msn .box1 .link:eq('+index+')'
					}
				}
				{
					name: '图片'
					route: ['images', index, 'image']
					updater: {
						type: 'attr'
						name: 'src'
						selector: '.auction_pages_msn .box1 .link:eq('+index+') img'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.auction_pages_msn .box2 .link').each ->
		index = $(this).index()
		configuration = {
			name: '链接（'+(index+1)+'）'
			fields: [
				{
					name: '标题'
					route: ['links', index, 'title']
					updater: {
						type: 'text',
						selector: '.auction_pages_msn .box2 .link:eq('+index+')'
					}
				}
				{
					name: '地址'
					route: ['links', index, 'url']
					updater: {
						type: 'attr'
						name: 'href'
						selector: '.auction_pages_msn .box2 .link:eq('+index+')'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)