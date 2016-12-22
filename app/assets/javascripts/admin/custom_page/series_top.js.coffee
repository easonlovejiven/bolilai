$ ->
	$('.series_top .label').each ->
		configuration = {
			name: '标签',
			fields: [
				{
					name: '标签',
					route: ['label'],
					update: {
						type: 'text',
						selector: '.series_top .label'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.series_top .title').each ->
		configuration = {
			name: '标题',
			fields: [
				{
					name: '标题',
					route: ['title'],
					update: {
						type: 'text',
						selector: '.series_top .title'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.series_top .subtitle').each ->
		configuration = {
			name: '副标题',
			fields: [
				{
					name: '副标题',
					route: ['subtitle'],
					update: {
						type: 'text',
						selector: '.series_top .subtitle'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.series_top .description').each ->
		configuration = {
			name: '描述',
			fields: [
				{
					name: '描述',
					route: ['description'],
					update: {
						type: 'text',
						selector: '.series_top .description'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
	$('.series_top .leftlink').each ->
		configuration = {
			name: '大图',
			fields: [
				{
					name: '地址',
					route: ['url'],
					update: {
						type: 'attr',
						name: 'href',
						selector: '.series_top .leftlink'
					}
				}
				{
					name: '图片',
					route: ['pic'],
					update: {
						type: 'attr',
						name: 'src',
						selector: '.series_top .leftlink .pic'
					}
				}
			]
		}
		$(this).addClass('preview_link').data('configuration', configuration)
