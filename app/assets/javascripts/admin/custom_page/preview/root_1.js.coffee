$ ->
  $.CoverWidget = {
    init: ->
      $this = this
      $(".covers").addClass('widget').data('configuration', $this.configuration())
    configuration: (index)->
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
  $.CoverWidget.init()
  $.PicList = {
    init: ->
      $this = this
      $(".pic_list").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: '封面',
        multi: true,
        source: ["pic_list"],
        fields: [
          {
            name: '图片',
            attr: 'pic'
          },
          {
            name: '地址',
            attr: 'url'
          }]
      }]
  }
  $.PicList.init()
  $.Xinpin = {
    init: ->
      $this = this
      $(".xinpin").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: "版块信息",
        source: ["xinpin_section"],
        fields: [
          {
            name: '名称',
            attr: 'name'
          }, {
            name: '地址',
            attr: 'url'
          }
        ]
      }, {
        name: '封面',
        multi: true,
        source: ["xinpin_section", "products"],
        fields: [
          {
            name: '图片',
            attr: 'pic'
          },
          {
            name: '地址',
            attr: 'url'
          }
        ]
      }]
  }
  $.Xinpin.init()
  #广告位
  $.Adv1 = {
    init: ->
      $this = this
      $(".advs1").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: "广告位",
        source: ["advs1"],
        fields: [
          {
            name: '地址',
            attr: 'url'
          }, {
            name: "图片",
            attr: 'pic'
          }
        ]
      }]
  }
  $.Adv1.init()
  $.Adv2 = {
    init: ->
      $this = this
      $(".advs2").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: "广告位",
        source: ["advs2"],
        fields: [
          {
            name: '地址',
            attr: 'url'
          }, {
            name: "图片",
            attr: 'pic'
          }
        ]
      }]
  }
  $.Adv2.init()
  #手串
  $.chuanshiWidget = {
    init: ->
      $this = this
      $(".chuanshi").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: "版块信息",
        source: ["chuanshi_section"],
        fields: [
          {
            name: '名称',
            attr: 'name'
          }, {
            name: '地址',
            attr: 'url'
          }
        ]
      }, {
        name: '分类导航',
        source: ["chuanshi_section", "categories"],
        multi: true,
        fields: [
          {
            name: '名称',
            attr: 'name'
          }, {
            name: '图片',
            attr: 'pic'
          },
          {
            name: '地址',
            attr: 'url'
          }
        ]
      }, {
        name: '产品列表'
        source: ["chuanshi_section", "products"],
        multi: true,
        fields: [
          {
            name: '产品id',
            attr: "id"
          }, {
            name: '标签',
            attr: "label"
          }, {
            name: '图片',
            attr: "pic"
          },
          {
            name: '地址',
            attr: "url"
          }]
      }]
  }
  $.chuanshiWidget.init()
  #项链
  $.xianglianWidget = {
    init: ->
      $this = this
      $(".xianglian").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: "版块信息",
        source: ["xianglian_section"],
        fields: [
          {
            name: '名称',
            attr: 'name'
          }, {
            name: '地址',
            attr: 'url'
          }
        ]
      }, {
        name: '分类导航',
        source: ["xianglian_section", "categories"],
        multi: true,
        fields: [
          {
            name: '名称',
            attr: 'name'
          }, {
            name: '图片',
            attr: 'pic'
          },
          {
            name: '地址',
            attr: 'url'
          }
        ]
      }, {
        name: '产品列表',
        source: ["xianglian_section", "products"],
        multi: true,
        fields: [
          {
            name: '产品id',
            attr: "id"
          }, {
            name: '标签',
            attr: "label"
          }, {
            name: '图片',
            attr: "pic"
          },
          {
            name: '地址',
            attr: "url"
          }]
      }, {
        name: '滚动图片',
        source: ["xianglian_section", "pic_list"],
        multi: true,
        fields: [
          {
            name: '产品id',
            attr: "id"
          }, {
            name: '标签',
            attr: "label"
          }, {
            name: '图片',
            attr: "pic"
          },
          {
            name: '地址',
            attr: "url"
          }]
      }]
  }
  $.xianglianWidget.init()
  #琥珀
  $.hupoWidget = {
    init: ->
      $this = this
      $(".hupo").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: "版块信息",
        source: ["hupo_section"],
        fields: [
          {
            name: '名称',
            attr: 'name'
          }, {
            name: '地址',
            attr: 'url'
          }
        ]
      }, {
        name: '分类导航',
        source: ["hupo_section", "categories"],
        multi: true,
        fields: [
          {
            name: '名称',
            attr: 'name'
          }, {
            name: '图片',
            attr: 'pic'
          },
          {
            name: '地址',
            attr: 'url'
          }
        ]
      }, {
        name: '产品列表',
        source: ["hupo_section", "products"],
        multi: true,
        fields: [
          {
            name: '产品id',
            attr: "id"
          }, {
            name: '标签',
            attr: "label"
          }, {
            name: '图片',
            attr: "pic"
          },
          {
            name: '地址',
            attr: "url"
          }]
      }, {
        name: '搜索类别',
        source: ["hupo_section", "shapes"],
        multi: true,
        fields: [
          {
            name: '名称',
            attr: "title"
          }, {
            name: '图片',
            attr: "pic"
          },
          {
            name: '地址',
            attr: "url"
          }]
      }]
  }
  $.hupoWidget.init()
  #客户点评
  $.PeopleWidget = {
    init: ->
      $this = this
      $(".people").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: '客户点评',
        source: ["people"],
        multi: true,
        fields: [
          {
            name: '名称',
            attr: 'name'
          },
          {
            name: '头像',
            attr: 'pic'
          }, {
            name: '描述',
            attr: 'desc'
          }, {
            name: '评价',
            attr: 'talk'
          }]
      }]
  }
  $.PeopleWidget.init()
  #文章列表
  $.Article1Widget = {
    init: ->
      $this = this
      $(".news").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: '资讯',
        source: ["news"],
        fields: [
          {
            name: '所属分类id',
            attr: 'category_id'
          },{
            name: '标签',
            attr: 'tag'
          }]
      }]
  }
  $.Article1Widget.init()
  #文章列表2
  $.Article2Widget = {
    init: ->
      $this = this
      $(".lesson").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: '课堂',
        source: ["lesson"],
        fields: [
          {
            name: '所属分类id',
            attr: 'category_id'
          },{
            name: '标签',
            attr: 'tag'
          }]
      }]
  }
  $.Article2Widget.init()
  #视频
  $.VedioWidget = {
    init: ->
      $this = this
      $(".brand_video").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: '视频(embed链接)',
        source: ["brand_video"],
        fields: [
          {
            name: '视频链接',
            attr: 'url'
          }]
      }]
  }
  $.VedioWidget.init()
 #体验中心
  $.StoresWidget = {
    init: ->
      $this = this
      $(".store_tabwp").addClass('widget').data('configuration', $this.configuration())
    configuration: ->
      return [{
        name: '体验店展示',
        source: ["stores"],
        multi: true,
        fields: [
          {
            name: '实体店名称',
            attr: 'name'
          },{
            name: '区域',
            attr: 'area'
          },{
            name: '区域拼音',
            attr: 'area_en'
          },{
            name: '城市',
            attr: 'city'
          },{
            name: '城市拼音',
            attr: 'city_en'
          },{
            name: '营业时间',
            attr: 'time'
          },{
            name: '地址',
            attr: 'address'
          },{
            name: '链接',
            attr: 'url'
          }]
      }]
  }
  $.StoresWidget.init()
