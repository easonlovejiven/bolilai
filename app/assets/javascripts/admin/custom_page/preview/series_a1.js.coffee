$ ->
  $.SeriersA1LargeWidget = {
    init: ->
      $this = this
      $(".series_a1 .large_list").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: "大型产品",
        source: ['products', 'large'],
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
  $.SeriersA1LargeWidget.init();

  $.SeriersA1SmallWidget = {
    init: ->
      $this = this
      $(".series_a1 .small_list").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: "小型产品",
        source: ['products', 'small',"ids"],
        multi: true,
        fields: [
          {
            name: '产品id',
            attr: 'id'
          }
        ]
      }]
  }
  $.SeriersA1SmallWidget.init();
