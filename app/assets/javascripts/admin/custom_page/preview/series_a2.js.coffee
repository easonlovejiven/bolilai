$ ->
  $.SeriersA2LargeWidget = {
    init: ->
      $this = this
      $(".series_a2 .pic_detail").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: "大图",
        source: ['link'],
        fields: [
          {
            name: '名称',
            attr: 'name'
          }, {
            name: '地址',
            attr: 'url'
          },{
            name: '图片',
            attr: 'pic'
          }
        ]
      }]
  }
  $.SeriersA2LargeWidget.init();

  $.SeriersA2SmallWidget = {
    init: ->
      $this = this
      $(".series_a2 .rightlink").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: "产品",
        source: ['product'],
        fields: [
          {
            name: '产品id',
            attr: 'id'
          }, {
            name: '标题',
            attr: 'title'
          },{
            name: '摘要',
            attr: 'summary'
          }
        ]
      }]
  }
  $.SeriersA2SmallWidget.init();
