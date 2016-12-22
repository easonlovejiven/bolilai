window.previewWidth = 640
window.previewHeight = 800
window.views = {
  category_style: ()->
    e = parseInt(previewWidth / 3)
    t = parseInt(e / 1.18)
    i = previewWidth
    n = 2 * t
    h = previewWidth / 3 * 59 / 107
    p = ['<style type="text/css">',
         ".brand_row{height:" + h + "px}",
         ".brand_row div {padding-top:" + (h - 30) / 2 + "px}",
         ".btn_zone{height:" + t / 2 + "px;}",
         ".btn_zone > div{height:" + (t / 2 - 20) + "px;line-height:" + (t / 2 - 20) + "px !important}",
         ".home_men,.home_women,.home_other{height:" + t + "px}",
         ".h_women_pic,.h_men_pic,.h_furniture_pic,.h_curio_pic,.h_outdoor_pic{height:" + t + "px;width:" + e + "px}",
         ".cate{width:" + e + "px;height:" + e + "px;}",
         ".cates{background-size:" + i + "px " + n + "px;}",
         ".cates.h_men_pic{background-position:0 0}",
         ".cates.h_women_pic{background-position:" + -e + "px 0}",
         ".h_women_other,.h_men_other{width:" + (i - e) + "px;height:" + t + "px;}",
         ".h_women_other p,.h_men_other p{height:" + t / 2 + "px;line-height:" + t / 2 + "px;width:" + (i - e) / 3 + "px}",
         ".cates.h_furniture_pic{background-position:" + 2 * (-e - 1) + "px 0}",
         ".cates.h_curio_pic{background-position: 0" + -t + "px}",
         ".cates.h_outdoor_pic{background-position: " + (-e - 1) + "px " + -t + "px}", "</style>"];
    $("head").append(p.join(" "))
  , new_style: ()->
    e = previewWidth
    t = ['<style type="text/css">',
         ".home_new .index_0,.home_new .index_0 img{width:" + .43 * e + "px; height:" + .43 * e * 30 / 29 + "px}",
         ".home_new .index_1,.home_new .index_1 img,.home_new .index_2,.home_new .index_2 img{width:" + (.46 * e - 1) + "px; height:" + .46 * e * 14 / 29 + "px}",
         "</style>"];
    $("head").append(t.join(" "))
  , recommend_list: ()->
    e = .5 * previewWidth
    t = ['<style type="text/css">', ".recommend_list .item>img{width:" + e + ";height:" + e + "px;}", "</style>"];
    $("head").append(t.join(" "))
  , slide_style: (e)->
    t = previewWidth
    i = t / 2;
    n = .9 * t / 2
    h = ['<style type="text/css">', ".slide_layer{height:" + (previewHeight - 50) + "px !important;}",
         ".slide_other{height:" + (previewHeight - n) + "px;}", ".turn_width{width:" + t + "px !important;}",
         ".turn_height{height:" + i + "px !important;}", ".turn_scroll_width{width:" + t * e + "px !important;}",
         "</style>"];
    $("head").append(h.join(" "))
}
$ ->
  app.lasy_load($('img'));
$ ->
  $.SliderWidget = {
    init: ->
      $this = this
      $(".home_turn").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: '封面',
        multi: true,
        source: ["covers"],
        fields: [
          {
            attr: 'name',
            name: '名称'
          },
          {
            attr: 'url',
            name: '地址'
          },
          {
            attr: 'pic',
            name: '图片'
          }
        ]
      }]
  }
  $.SliderWidget.init()
  $.NavWidget = {
    init: ->
      $this = this
      $(".navs").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: '封面',
        multi: true,
        source: ["navs"],
        fields: [
          {
            attr: 'name',
            name: '名称'
          }, {
            attr: 'pic',
            name: '图标地址'
          },
          {
            attr: 'url',
            name: '地址'
          }
        ]
      }]
  }
  $.NavWidget.init()
  $.CategoryWidget = {
    init: ->
      $this = this
      $(".home_cate").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: '封面',
        multi: true,
        source: ["categories"],
        fields: [
          {
            attr: 'name',
            name: '名称'
          },
          {
            attr: 'url',
            name: '地址'
          },
          {
            attr: 'pic',
            name: '图片'
          }
        ]
      }]
  }
  $.CategoryWidget.init()
  $.NewWidget = {
    init: ->
      $this = this
      $(".home_new").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: "版块",
        source: ["products_section2"],
        fields: [
          {
            attr: 'title',
            name: '版块名称'
          }
        ]
      }, {
        name: '封面',
        multi: true,
        source: ["products_section2", "images"],
        fields: [
          {
            attr: 'name',
            name: '名称'
          },
          {
            attr: 'url',
            name: '地址'
          },
          {
            attr: 'pic',
            name: '图片'
          }
        ]
      }]
  }
  $.NewWidget.init()
  $.HotWidget = {
    init: ->
      $this = this
      $(".home_recommend").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: "版块",
        source: ["products_section1"],
        fields: [
          {
            attr: 'title',
            name: '版块名称'
          }
        ]
      }, {
        name: '封面',
        multi: true,
        source: ["products_section1", "products"],
        fields: [
          {
            attr: 'id',
            name: '产品id'
          }
        ]
      }]
  }
  $.HotWidget.init()
  $.FooterWidget = {
    init: ->
      $this = this
      $(".footer").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: "首页底部",
        source: ["footer"],
        multi: true,
        fields: [
          {
            attr: 'name',
            name: '名称'
          }, {
            attr: 'url',
            name: '地址'
          }
        ]
      }]
  }
  $.FooterWidget.init()
