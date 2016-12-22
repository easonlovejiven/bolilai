$ ->
	$('.background .link').each ->
		index = $(this).index()
		configuration = {
			name: '背景（'+(index+1)+'）'+($('.background .link')[index].text),
			fields: [
				# {
				# 	name: '名称',
				# 	route: ['backgrounds', index, 'name'],
				# 	updater: {
				# 		type: 'text'
				# 		selector: '.background .link:eq('+(index)+') .name'
				# 	}
				# }
				{
					name: '地址',
					route: ['backgrounds', index, 'url'],
					updater: {
						type: 'attr',
						name: 'href',
						selector: '.background .link:eq('+(index)+')'
					}
				}
				{
					name: '图片（1920*1500）',
					route: ['backgrounds', index, 'image'],
					updater: {
						type: 'attr',
						name: 'src',
						selector: '.background .link:eq('+(index)+') .image'
					}
				}
				{
					name: '背景颜色',
					route: ['backgrounds', index, 'color'],
					updater: {
						type: 'css',
						name: 'background-color',
						selector: '.background .link:eq('+(index)+')'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
