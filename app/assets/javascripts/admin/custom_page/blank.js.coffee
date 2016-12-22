$ ->
	$('body > div:nth(0)').each ->
		configuration = {
			name: '样式'
			fields: [
				{
					name: '背景颜色',
					route: ['style', 'background-color'],
					updater: { type: 'css', name: 'background-color', selector: 'body > div:nth(0)' }
				}
				{
					name: '背景图片',
					route: ['style', 'background-image'],
					updater: { type: 'css', name: 'background-image', selector: 'body > div:nth(0)' }
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
