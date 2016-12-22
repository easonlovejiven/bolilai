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
	$('.top .link').each ->
		configuration = {
			name: '头图',
			fields: [
				{
					name: '名称',
					route: ['images', 0, 'name'],
					updater: {
						type: 'attr',
						name: 'alt',
						selector: '.top .link .pic'
					}
				}
				{
					name: '地址',
					route: ['images', 0, 'url'],
					updater: {
						type: 'attr',
						name: 'href',
						selector: '.top .link'
					}
				}
				{
					name: '图片',
					route: ['images', 0, 'pic'],
					updater: {
						type: 'attr',
						name: 'src',
						selector: '.top .link .pic'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.contentbox .list li .link').each ->
		index = $(this).parent().index()+1
		configuration = {
			name: '小图（'+index+'）',
			fields: [
				{
					name: '名称',
					route: ['images', index, 'name'],
					updater: {
						type: 'attr',
						name: 'alt',
						selector: '.contentbox li:eq('+(index-1)+') .link .pic'
					}
				}
				{
					name: '地址',
					route: ['images', index, 'url'],
					updater: {
						type: 'attr',
						name: 'href',
						selector: '.contentbox li:eq('+(index-1)+') .link'
					}
				}
				{
					name: '图片',
					route: ['images', index, 'pic'],
					updater: {
						type: 'attr',
						name: 'src',
						selector: '.contentbox li:eq('+(index-1)+') .link .pic'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)

