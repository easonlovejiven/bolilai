#$ ->
#	$('.series_link a').each ->
#		configuration = {
#			name: '图片',
#			fields: [
#				{
#					name: '名称',
#					route: ['image', 'name'],
#					update: {
#						type: 'attr',
#						name: 'alt',
#						selector: '.series_link .pic'
#					}
#				}
#				{
#					name: '地址',
#					route: ['image', 'url'],
#					update: {
#						type: 'attr',
#						name: 'href',
#						selector: '.series_link a'
#					}
#				}
#				{
#					name: '图片',
#					route: ['image', 'pic'],
#					update: {
#						type: 'attr',
#						name: 'src',
#						selector: '.series_link .pic'
#					}
#				}
#				{
#					name: '宽度',
#					route: ['image', 'width'],
#					update: {
#						type: 'attr',
#						name: 'width',
#						selector: '.series_link .pic'
#					}
#				}
#				{
#					name: '高度',
#					route: ['image', 'height'],
#					update: {
#						type: 'attr',
#						name: 'height',
#						selector: '.series_link .pic'
#					}
#				}
#			]
#		}
#		$(this).addClass('preview_link').data('configuration', configuration)
#	$('.series_link object').each ->
#		configuration = {
#			name: 'FLASH',
#			fields: [
#				{
#					name: '地址',
#					route: ['flash', 'src'],
#					update: {
#						type: 'attr',
#						name: 'src',
#						selector: '.series_link object embed'
#					}
#				}
#				{
#					name: '宽度',
#					route: ['flash', 'width'],
#					update: {
#						type: 'attr',
#						name: 'width',
#						selector: '.series_link object embed'
#					}
#				}
#				{
#					name: '高度',
#					route: ['flash', 'height'],
#					update: {
#						type: 'attr',
#						name: 'height',
#						selector: '.series_link object embed'
#					}
#				}
#			]
#		}
#		$(this).addClass('preview_link').data('configuration', configuration)
