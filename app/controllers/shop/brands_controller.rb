##
# = 商城 品牌 界面
#
class Shop::BrandsController < Shop::ApplicationController
  caches_action :index, :show, :expires_in => 10.hour.to_i, :cache_path => Proc.new { |controller| controller.request.fullpath.gsub(/&?_weimall_session=[^&]*/, '') }

  ##
  # == 列表
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /auction/brands
  #
  # ==== Parameters
  #
  # page :: 页数
  # per_page :: 每页个数
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <brands type="Array">
  #       <brand type="Shop::Brand">
  #         <id type="integer">ID</id>
  #         <name>英文名</name>
  #         <chinese>中文名</chinese>
  #         <initial>首字母</initial>
  #         <genre>类型</genre>
  #         <pic>图片</pic>
  #         <recommend>推荐，可以为%w[featured newest hot]之一</recommend>
  #         <order type="integer">排序</order>
  #         <introduced>介绍</introduced>
  #         <material>材质</material>
  #         <summary>概要</summary>
  #       </brand>
  #     </brands>
  #     <categories>
  #       <category>
  #         <id>一级分类ID</id>
  #         <brand_ids>品牌ID列表</brand_ids>
  #       </category>
  #     </categories>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #     "brands" : [
  #       {
  #         "id" : ID,
  #         "name" : 英文名,
  #         "chinese" : 中文名,
  #         "initial" : 首字母,
  #         "genre" : 类型,
  #         "pic" : 图片,
  #         "recommend" : 推荐，可以为%w[featured newest hot]之一,
  #         "order" : 排序,
  #         "introduced" : 介绍,
  #         "material" : 材质,
  #         "summary" : 概要,
  #       },
  #     ],
  #     "categories" : [
  #       {
  #         "id": 一级分类ID,
  #         "brand_ids": 品牌ID列表,
  #       }
  #     ]
  #   }
  #
  # ==== YAML
  #
  #   ---
  #     brands:
  #       -
  #         id: ID
  #         name: 英文名
  #         chinese: 中文名
  #         initial: 首字母
  #         genre: 类型
  #         pic: 图片
  #         recommend: 推荐，可以为%w[featured newest hot]之一
  #         order: 排序
  #         introduced: 介绍
  #         material: 材质
  #         summary: 概要
  #     categories:
  #       -
  #         id: 一级分类ID
  #         brand_ids: 品牌ID列表
  #
  def index
    @brands = Shop::Brand.active.published._where(params[:where])._order(params[:order] || {"`order`" => 'ASC'}).page(params[:page]).per(params[:per_page] || 10)

    respond_to do |format|
      format.html
      format.xml { @data = params[:response] == 'slim' ? (brands = @brands.select(%w[id name chinese initial])) && {brands: brands.arel.engine.connection.execute(brands.to_sql).to_a.map { |record| [brands.select_values, record].transpose.to_h }} : {brands: @brands, categories: Shop::Product.active.published.where(mall_id: 1).group(:category1_id, :brand_id).count.group_by { |(category1_id, brand_id), count| category1_id }.map { |category1_id, group| {id: category1_id, brand_ids: group.map(&:first).map(&:second).join(',')} }} }
    end
  end

  ##
  # == 查看
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /auction/brand/:id
  #
  # ==== Parameters
  #
  # id :: 品牌ID
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <brand type="Shop::Brand">
  #       <id type="integer">ID</id>
  #       <name>英文名</name>
  #       <chinese>中文名</chinese>
  #       <initial>首字母</initial>
  #       <genre>类型</genre>
  #       <pic>图片</pic>
  #       <link>圣经链接</link>
  #       <shop_link>旗舰店链接</shop_link>
  #       <title>标题</title>
  #       <description>描述</description>
  #       <pronunciation>发音</pronunciation>
  #       <year>年份</year>
  #       <keywords>关键字</keywords>
  #       <recommend>推荐，可以为%w[featured newest hot]之一</recommend>
  #       <order type="integer">排序</order>
  #       <introduced>介绍</introduced>
  #       <material>材质</material>
  #       <summary>概要</summary>
  #       <country>
  #         <id>国家ID</id>
  #         <name>名称</name>
  #       </country>
  #     </brand>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #     "brand" : {
  #       "id" : ID,
  #       "name" : 英文名,
  #       "chinese" : 中文名,
  #       "initial" : 首字母,
  #       "genre" : 类型,
  #       "pic" : 图片,
  #       "link" : 圣经链接,
  #       "shop_link" : 旗舰店链接,
  #       "title" : 标题,
  #       "description" : 描述,
  #       "pronunciation" : 发音,
  #       "year" : 年份,
  #       "keywords" : 关键字,
  #       "recommend" : 推荐，可以为%w[featured newest hot]之一,
  #       "order" : 排序,
  #       "introduced" : 介绍,
  #       "material" : 材质,
  #       "summary" : 概要,
  #       "country" : {
  #         "id" : 国家ID,
  #         "name" : 名称,
  #       }
  #     },
  #   }
  #
  # ==== YAML
  #
  #   ---
  #     brand:
  #       id: ID
  #       name: 英文名
  #       chinese: 中文名
  #       initial: 首字母
  #       genre: 类型
  #       pic: 图片
  #       link: 圣经链接
  #       shop_link: 旗舰店链接
  #       title: 标题
  #       description: 描述
  #       pronunciation: 发音
  #       year: 年份
  #       keywords: 关键字
  #       recommend: 推荐，可以为%w[featured newest hot]之一
  #       order: 排序
  #       introduced: 介绍
  #       material: 材质
  #       summary: 概要
  #       country:
  #         id: 国家ID
  #         name: 名称
  #
  def show
    @brand = Shop::Brand.acquire(params[:id])

    respond_to do |format|
      format.html
      format.xml { @data = {'brand' => @brand.assign_options(Shop::Brand.complete_xml_options)} }
    end
  end

  def top # :nodoc:
    redirect_to condition_auction_products_path(:format => params[:_format])
  end

  private

  def authorized?
    super
    true
  end
end
