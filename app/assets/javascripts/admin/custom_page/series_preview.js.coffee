$ ->
	$('.auction_pages .series_preview').each ->
		configuration = {
			name: '参数'
			fields: [
				{
					name: '颜色（coffee/brown/purple/green/orange/navy）'
					route: ['theme']
					updater: {
						type: 'css'
						name: 'background-color'
						selector: '.auction_pages .series_preview'
					}
				}
				{
					name: '排列（1/2/3）'
					route: ['arrange']
					updater: {
						type: 'text'
						selector: '.auction_pages .series_preview'
					}
				}
				{
					name: '底边距（0/空）'
					route: ['style', 'margin-bottom']
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
