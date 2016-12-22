$ ->
	$('.series_topics .link').each ->
		index = $(this).index()
		configuration = {
			name: '大图（'+(index+1)+'）',
			fields: [
				{
					name: '名称',
					route: ['links', index, 'name'],
					update: {
						type: 'attr',
						name: 'alt',
						selector: '.series_topics .link:eq('+index+') .pic'
					}
				}
				{
					name: '地址',
					route: ['links', index, 'url'],
					update: {
						type: 'attr',
						name: 'href',
						selector: '.series_topics .link:eq('+index+') a'
					}
				}
				{
					name: '图片',
					route: ['links', index, 'pic'],
					update: {
						type: 'attr',
						name: 'src',
						selector: '.series_topics .link:eq('+index+') .pic'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)