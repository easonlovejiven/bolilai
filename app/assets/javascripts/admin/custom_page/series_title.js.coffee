$ ->
	$('.series_title h3').each ->
		configuration = {
			name: '名称',
			fields: [
				{
					name: '名称',
					route: ['title'],
					update: {
						type: 'text',
						selector: '.series_title h3'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
