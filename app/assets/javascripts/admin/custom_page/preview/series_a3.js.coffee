$ ->
  $.SeriersA3LargeWidget = {
    init: ->
      $this = this
      $(".series_a3 .product_list").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: "大图",
        source: ['products'],
        multi: true,
        fields: [
          {
            name: '产品id',
            attr: 'id'
          }, {
            name: '标题',
            attr: 'title'
          },{
            name: '图片',
            attr: 'pic'
          }
        ]
      }]
  }
  $.SeriersA3LargeWidget.init();
