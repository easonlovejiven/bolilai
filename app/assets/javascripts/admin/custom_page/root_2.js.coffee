$ ->
	$('.categories .link').each ->
		index = $(this).index()
		configuration = {
			name: '分类（'+(index+1)+'）',
			fields: [
				{
					name: 'ID',
					route: ['category', 'ids', index],
					callback: ->
						$.ajax
							url: '/auction/categories/'+this.value+'.json',
							context: $('.categories .link:eq('+this.route[2]+')'),
							success: (data) -> $(this).attr('href', '/auction/products?where[category1_id]='+data.category.id).text(data.category.name)
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.brands .link').each ->
		index = $(this).index()
		index += 15 if $(this).is('.link32, .link63, .link34, .link50')
		configuration = {
			name: '品牌（'+(index+1)+'）',
			fields: [
				{
					name: 'ID',
					route: ['brand', 'ids', index],
					callback: ->
						$.ajax
							url: '/auction/brands/'+this.value+'.json',
							context: $('.brands .link:eq('+this.route[2]+')'),
							success: (data) -> $(this).attr('href', '/auction/products?where[brand_id]='+data.brand.id).text(if $(this).is('.link32, .link63, .link34, .link50') then '' else data.brand.name)
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.covers .link').each ->
		index = $(this).index()
		configuration = {
			name: '封面（'+(index+1)+'）',
			fields: [
				{
					name: '名称',
					route: ['covers', index, 'name']
				},
				{
					name: '地址',
					route: ['covers', index, 'url'],
					update: {
						type: 'attr',
						name: 'href',
						selector: '.covers .link:eq('+index+')'
					}
				},
				{
					name: '图片',
					route: ['covers', index, 'pic'],
					update: {
						type: 'attr',
						name: 'src',
						selector: '.covers .link:eq('+index+') img:first'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.newslides .link').each ->
		index = $(this).index()
		configuration = {
			name: '新品（'+(index+1)+'）',
			fields: [
				{
					name: '名称',
					route: ['slides', index, 'name'],
					update: {
						type: 'text',
						selector: '.newslides .link:eq('+index+') .imgText .name'
					}
				},
				{
					name: '地址',
					route: ['slides', index, 'url'],
					update: {
						type: 'attr',
						name: 'href',
						selector: '.newslides .link:eq('+index+')'
					}
				},
				{
					name: '图片',
					route: ['slides', index, 'pic'],
					update: {
						type: 'attr',
						name: 'src',
						selector: '.newslides .link:eq('+index+') .pic'
					}
				},
				{
					name: '描述',
					route: ['slides', index, 'description'],
					input: 'textarea',
					update: {
						type: 'text',
						selector: '.newslides .link:eq('+index+') .imgText .description'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.events .link').each ->
		index = $(this).index()
		configuration = {
			name: '活动（'+(index+1)+'）',
			fields: [
				{
					name: '名称',
					route: ['events', index, 'name'],
					update: {
						type: 'text',
						selector: '.events .link:eq('+index+') .imgText .name'
					}
				},
				{
					name: '地址',
					route: ['events', index, 'url'],
					update: {
						type: 'attr',
						name: 'href',
						selector: '.events .link:eq('+index+')'
					}
				},
				{
					name: '图片',
					route: ['events', index, 'pic'],
					update: {
						type: 'attr',
						name: 'src',
						selector: '.events .link:eq('+index+') .pic'
					}
				},
				{
					name: '描述',
					route: ['events', index, 'description'],
					input: 'textarea',
					update: {
						type: 'text',
						selector: '.events .link:eq('+index+') .imgText .description'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.topics .link').each ->
		index = $(this).index()
		configuration = {
			name: '新品（'+(index+1)+'）',
			fields: [
				{
					name: '名称',
					route: ['topics', index, 'name'],
					update: {
						type: 'text',
						selector: '.topics .link:eq('+index+') .nav'
					}
				},
				{
					name: '地址',
					route: ['topics', index, 'url'],
					update: {
						type: 'attr',
						name: 'href',
						selector: '.topics .link:eq('+index+')'
					}
				},
				{
					name: '图片',
					route: ['topics', index, 'pic'],
					update: {
						type: 'attr',
						name: 'src',
						selector: '.topics .link:eq('+index+') .pic'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.peple .mod, peple .avatar').each ->
		configuration = {
			name: '人物',
			fields: [
				{
					name: '名称',
					route: ['people', 'name']
				},
				{
					name: '地址',
					route: ['people', 'url'],
					update: {
						type: 'attr',
						name: 'href',
						selector: '.peple .mod, peple .avatar'
					}
				},
				{
					name: '图片',
					route: ['people', 'pic'],
					update: {
						type: 'attr',
						name: 'src',
						selector: '.peple .avatar .pic'
					}
				},
				{
					name: '描述',
					route: ['people', 'description'],
					input: 'textarea',
					update: {
						type: 'text',
						selector: '.peple .mod .text'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.wall .link').each ->
		index = $(this).closest('tr').index()
		index2 = $(this).closest('table').index()
		configuration = {
			name: '图片（'+(index+1)+'，'+(index2+1)+'）',
			fields: [
				{
					name: '名称',
					route: ['walls', index, 'photos', index2, 'name']
				},
				{
					name: '地址',
					route: ['walls', index, 'photos', index2, 'url'],
					update: {
						type: 'attr',
						name: 'href',
						selector: '.wall table:eq('+index2+') .link:eq('+index+')'
					}
				},
				{
					name: '图片',
					route: ['walls', index, 'photos', index2, 'pic'],
					update: {
						type: 'attr',
						name: 'src',
						selector: '.wall table:eq('+index2+') .link:eq('+index+') .pic'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
