$ ->
	$('.box_top').each ->
		configuration = {
			name: '头图',
			fields: [
				{
					name: '背景图片',
					route: ['banner', 'background-image'],
					updater: {
						type: 'css',
						name: 'background-image',
						selector: '.box_top'
					}
				}
				{
					name: '背景颜色',
					route: ['banner', 'background-color'],
					updater: {
						type: 'css',
						name: 'background-color',
						selector: '.box_top'
					}
				}
				{
					name: '高度',
					route: ['banner', 'height'],
					updater: {
						type: 'css',
						name: 'height',
						selector: '.box_top .content'
					}
				}
				{
					name: 'Swf',
					route: ['banner', 'flash']
				}
				{
					name: '链接(有填1/没有留空)',
					route: ['banner', 'url'],
					updater: {
						type: 'attr',
						name: 'href',
						selector: '.box_top .content .topurl'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('#nav_new').each ->
		configuration = {
			name: '最新消息',
			fields: [
				{
					name: '文字',
					route: ['news'],
					updater: {
						type: 'text',
						selector: '#nav_new'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.iphone_pic').each ->
		configuration = {
			name: '近期剧透',
			fields: [
				{
					name: '图片',
					route: ['latest'],
					updater: {
						type: 'css',
						name: 'background-image',
						selector: '.iphone_pic .new_pic'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('#box_palette').each ->
		configuration = {
			name: '自定义模块',
			fields: [
				{
					name: '图片',
					route: ['palette', 'pic'],
					updater: {
						type: 'attr',
						name: 'src',
						selector: '#box_palette .pic'
					}
				}
				{
					name: '背景颜色',
					route: ['palette', 'background-color'],
					updater: {
						type: 'css',
						name: 'background-color',
						selector: '#box_palette'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)


