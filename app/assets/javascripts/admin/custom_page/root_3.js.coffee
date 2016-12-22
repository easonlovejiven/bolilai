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
	$('.hbrands .list .link').each ->
		index = $(this).index()
		configuration = {
			name: '品牌（'+(index+1)+'）',
			fields: [
				{
					name: 'ID',
					route: ['brand', 'ids', index],
					callback: -> $('.hbrands .list .link:eq('+this.route[2]+')').attr('href', '/auction/products?where[brand_id]='+this.value)
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.specials .title').each ->
		configuration = {
			name: '推荐标题',
			fields: [
				{
					name: '英文名称',
					route: ['specials_title', 'en_name'],
					update: {
						type: 'text',
						selector: '.specials .title h3'
					}
				},
				{
					name: '中文名称',
					route: ['specials_title', 'cn_name'],
					update: {
						type: 'text',
						selector: '.specials .title span'
					}
				},
				{
					name: '地址',
					route: ['specials_title', 'url'],
					update: {
						type: 'attr',
						name: 'href',
						selector: '.specials .title'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.specials .link').each ->
		index1 = $(this).closest('ul').index()
		index2 = $(this).closest('li').index()
		index = index1*2 + index2
		configuration = {
			name: '推荐 （'+(index+1)+'）',
			fields: [
				{
					name: '名称',
					route: ['specials', index, 'name'],
					update: {
						type: 'attr',
						name: 'alt',
						selector: '.specials ul:eq('+index1+') li:eq('+index2+') .link .pic'
					}
				},
				{
					name: '地址',
					route: ['specials', index, 'url'],
					update: {
						type: 'attr',
						name: 'href',
						selector: '.specials ul:eq('+index1+') li:eq('+index2+') .link'
					}
				},
				{
					name: '图片',
					route: ['specials', index, 'pic'],
					update: {
						type: 'attr',
						name: 'src',
						selector: '.specials ul:eq('+index1+') li:eq('+index2+') .link .pic'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.People .title').each ->
		configuration = {
			name: '人物标题',
			fields: [
				{
					name: '英文名称',
					route: ['people', 'title', 'en_name'],
					update: {
						type: 'text',
						selector: '.People .title h3'
					}
				},
				{
					name: '中文名称',
					route: ['people', 'title', 'cn_name'],
					update: {
						type: 'text',
						selector: '.People .title span'
					}
				},
				{
					name: '地址',
					route: ['people', 'title', 'url'],
					update: {
						type: 'attr',
						name: 'href',
						selector: '.People .title'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.People .pic').each ->
		configuration = {
			name: '人物',
			fields: [
				{
					name: '名称',
					route: ['people', 'name'],
					update: {
						type: 'attr',
						name: 'alt',
						selector: '.People .pic img'
					}
				},
				{
					name: '地址',
					route: ['people', 'url'],
					update: {
						type: 'attr',
						name: 'href',
						selector: '.People .pic'
					}
				},
				{
					name: '图片',
					route: ['people', 'pic'],
					update: {
						type: 'attr',
						name: 'src',
						selector: '.People .pic img'
					}
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
	$('.imgblock .link').each ->
		index = $(this).index()
		configuration = {
			name: '图片（'+(index+1)+'）',
			fields: [
				{
					name: '名称',
					route: ['images', index, 'name']
				},
				{
					name: '地址',
					route: ['images', index, 'url'],
					update: {
						type: 'attr',
						name: 'href',
						selector: '.imgblock .link:eq('+index+')'
					}
				},
				{
					name: '图片',
					route: ['images', index, 'pic'],
					update: {
						type: 'attr',
						name: 'src',
						selector: '.imgblock .link:eq('+index+') img'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
