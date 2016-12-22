$ ->
	$('.series_a8 .title').each ->
		configuration = {
			name: '标题',
			fields: [
				{
					name: '标题',
					route: ['title'],
					update: {
						type: 'text',
						selector: '.series_a8 .title'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.series_a8 .description').each ->
		configuration = {
			name: '描述',
			fields: [
				{
					name: '描述',
					route: ['description'],
					input: 'textarea',
					update: {
						type: 'text',
						selector: '.series_a8 .description'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.series_a8 .leftlink').each ->
		configuration = {
			name: '大图',
			fields: [
				{
					name: '地址',
					route: ['url'],
					update: {
						type: 'attr',
						name: 'href',
						selector: '.series_a8 .leftlink'
					}
				}
				{
					name: '图片',
					route: ['pic'],
					update: {
						type: 'attr',
						name: 'src',
						selector: '.series_a8 .leftlink .pic'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
