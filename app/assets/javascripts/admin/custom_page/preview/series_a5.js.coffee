#$ ->
#	$('.product_mod .product_list').each ->
#		index = $(this).index()
#		$(this).find('.link').each ->
#			index_product = $(this).index()
#			configuration = {
#				name: ''+($('.navlist .link')[index].text)+'产品（'+(index_product+1)+'）',
#				fields: [
#					{
#					name: 'ID',
#					route: ['sections', index, 'products', index_product, 'id'],
#					callback: ->
#						$.ajax
#							url: '/auction/products/'+this.value+'.json',
#							context: $('.product_mod .product_list:eq('+index+') .link:eq('+index_product+')'),
#							success: (data) ->
#								$(this).attr('href', '/auction/products/'+data.product.id)
#								$(this).find('.pic').attr('src', data.product.major_pic+'.promote.jpg')
#								$(this).find('.summary span').text(data.product.brand.name)
#								$(this).find('.summary em').text(data.product.name.sub(data.product.brand.name, ""))
#								$(this).find('.MarketPrice span').text(data.product.price)
#								$(this).find('.WeimallPrice span').text(data.product.discount)
#					}
#					{
#						name: '标题',
#						route: ['sections', index, 'products', index_product, 'title'],
#						update: {
#							type: 'text',
#							selector: '.product_mod .product_list:eq('+index+') .link:eq('+index_product+') .title'
#						}
#					}
#				]
#			}
#			$(this).addClass('preview_link').data('configuration', configuration)
#	$('.product_mod .product_list .morelink').each ->
#		index = $(this).index()
#		configuration = {
#			name: '更多',
#			fields: [
#				{
#					name: '地址',
#					route: ['sections', index, 'more'],
#					update: {
#						type: 'attr',
#						name: 'href',
#						selector: '.product_mod .product_list:eq('+index+') .morelink'
#					}
#				}
#			]
#		}
#		$(this).addClass('preview_link').data('configuration', configuration)
#
$ ->
  $.SeriersA5LargeWidget = {
    init: ->
      $this = this
      $(".series_a5 .product_list").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: "类别",
        source: ['sections'],
        multi: true,
        fields: [
          {
            name: '分类名称',
            attr: 'name'
          }, {
            name: '更多地址',
            attr: 'more'
          }
        ]
      },{
        name: "产品",
        source: ['sections','products'],
        multi: true,
        fields: [
          {
            name: '产品id',
            attr: 'id'
          }, {
            name: '标题',
            attr: 'title'
          }
        ]
      }]
  }
  $.SeriersA5LargeWidget.init();

  $.SeriersA5MoreWidget = {
    init: ->
      $this = this
      $(".series_a5 .morelink").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: "更多",
        source: ['sections','more'],
        fields: [
          {
            name: '名称',
            attr: 'name'
          },{
            name: '地址',
            attr: 'href'
          }
        ]
      }]
  }
  $.SeriersA5MoreWidget.init();
