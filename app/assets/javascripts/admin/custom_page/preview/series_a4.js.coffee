$ ->
  $.SeriersA4LargeWidget = {
    init: ->
      $this = this
      $(".series_a4 .product_list").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: "产品",
        source: ['products'],
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
  $.SeriersA4LargeWidget.init();

  $.SeriersA4MoreWidget = {
    init: ->
      $this = this
      $(".series_a4 .morelink").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: "更多",
        source: ['more'],
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
  $.SeriersA4MoreWidget.init();
