##
# = 商城 产品 界面
#
class Shop::ProductsController < Shop::ApplicationController
  before_filter :update_readings_count, :only => :show
  caches_action :index, :expires_in => 3600,
                :cache_path => Proc.new { |ctr| Digest::MD5.hexdigest(ctr.generate_cache_url) }, :if => Proc.new { |ctr| ctr.request.params['ids'].blank? }
  caches_action :show, :expires_in => 1.month.to_i, :cache_path => Proc.new { |ctr| ctr.generate_cache_url }
  # caches_action :google, :brands, :vizury, :latest_products, :expires_in => 3600, :cache_path => Proc.new { |controller| controller.request.fullpath.gsub(/&?_weimall_session=[^&]*/, '') }

  ##
  # == 列表
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/products
  #
  # ==== Parameters
  #
  # ids :: ID列表，用逗号分隔
  # \where[id] :: ID
  # \where[id][] :: （多选）
  # \where[mall_id] :: 商城ID，默认为1
  # \where[mall_id][] :: （多选）
  # \where[category1_id] :: 一级分类ID
  # \where[category1_id][] :: （多选）
  # \where[category2_id] :: 二级分类ID
  # \where[category2_id][] :: （多选）
  # \where[category3_id] :: 三级分类ID
  # \where[category3_id][] :: （多选）
  # \where[brand_id] :: 品牌ID
  # \where[brand_id][] :: （多选）
  # \where[multibuy_id] :: 连拍ID
  # \where[target] :: 对象，可以为{ 'men' => '男', 'women' => '女', 'nogender' => '无性别', 'children' => '儿童', }之一
  # \where[target][] :: （多选）
  # \where[color] :: 颜色，可以为{ 'red' => '红', 'pink' => '粉', 'purple' => '紫', 'blue' => '蓝', 'green' => '绿', 'yellow' => '黄', 'orange' => '橙', 'brown' => '棕', 'gray' => '灰', 'black' => '黑', 'white' => '白', 'silver' => '银', 'multicolor' => '彩' }之一
  # \where[color][] :: （多选）
  # \where[measure] :: 尺寸
  # \where[measure][] :: （多选）
  # \where[recommend] :: 推荐，可以为{ 'featured' => '精选', 'newest' => '最新', 'hot' => '热门', }之一
  # \where[price][操作符] :: 价格
  # \where[point][操作符] :: （停用）积分，默认为空
  # \where[unsold_count][操作符] :: 未售出数
  # \where[arrived_at][操作符] :: 上架时间
  # \where[updated_at][操作符] :: 更新时间
  # \order[price] :: 价格顺序
  # \order[point] :: 积分顺序
  # \order[created_at] :: （停用）创建时间顺序
  # \order[published_at] :: （停用）发布时间顺序
  # \order[arrived_at] :: 上架时间顺序
  # \order[updated_at] :: 更新时间顺序
  # \order[percent] :: 折扣顺序
  # \order[scarcity] :: 稀缺顺序
  # \order[readings_count] :: 浏览数排序
  # \values[属性名] :: 属性值
  # \values[属性名][] :: （多选）
  # keyword :: 关键字
  # page :: 页数
  # per_page :: 每页个数
  # response :: \输出格式，可以为%w[simple summary complete]之一，其中summary必须传ids，complete必须使用 show 接口
  # 操作符 :: \可以为%w[eq gt gteq lt lteq noteq]之一
  # 顺序 :: \可以为%w[asc desc]之一
  #
  # === Response
  #
  # ==== XML
  #
  # ===== simple
  # ===== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <products type="Array">
  #       <product type="Shop::Product">
  #         <id type="integer">ID</id>
  #         <discount type="integer">销售价</discount>
  #         <zoom type="integer">缩放</zoom>
  #         <updated_at type="datetime">更新时间</updated_at>
  #       </product>
  #     </products>
  #     <products_count>产品个数</products_count>
  #     <products_facet>产品分面</products_facet>
  #     <sticky_xml>置顶XML</sticky_xml>
  #     <sticky type="Shop::Sticky">
  #       <images type="Array">
  #         <image type="Shop::StickiesImage">
  #           <id type="integer">ID</id>
  #           <name>名称</name>
  #           <pic>图片</pic>
  #           <url>地址</url>
  #           <sequence>顺序</sequence>
  #           <dimension_x>宽度</dimension_x>
  #           <dimension_y>高度</dimension_y>
  #         </image>
  #       </images>
  #     </sticky>
  #   </response>
  #
  # ===== summary
  # ==== JSON
  #
  # ===== simple
  # ===== JSON
  #
  #   {
  #     "products" : [
  #       {
  #         "id" : ID,
  #         "discount" : 销售价,
  #         "zoom" : 缩放,
  #         "updated_at" : 更新时间,
  #       },
  #     ],
  #     "products_count" : 产品个数,
  #     "products_facet" : 产品分面,
  #     "sticky_xml" : 置顶XML,
  #     "sticky" : {
  #       "images" : [
  #         {
  #           "id" : ID,
  #           "name" : 名称,
  #           "pic" : 图片,
  #           "url" : 路径,
  #           "sequence" : 顺序,
  #           "dimension_x" : 宽度,
  #           "dimension_y" : 高度,
  #         },
  #       ]
  #     }
  #   }
  #
  # ===== summary
  # ===== JSON
  #
  #   {
  #     "products" : [
  #       {
  #         "id" : ID,
  #         "mall_id" : 商城ID,
  #         "brand_id" : 品牌ID,
  #         "category1_id" : 一级分类ID,
  #         "multibuy_id": 连拍ID,
  #         "label" : 备注,
  #         "prefix" : 前缀,
  #         "name" : 名称,
  #         "pic" : 图片,
  #         "major_pic" : 主图片,
  #         "model_pic" : 模特图片,
  #         "color_name" : 颜色名称,
  #         "percent_text" : 折扣说明,
  #         "target" : 对象，可以为[男 女 中性 儿童]之一,
  #         "price" : 市场价,
  #         "discount" : 销售价,
  #         "minimum_price" : 最低价,
  #         "point" : 积分,
  #         "zoom" : 缩放,
  #         "updated_at" : 更新时间,
  #         "sell_current" : 当前销售,
  #         "unsold_count" : 未出售数量,
  #         "measures_unsold_count" : 尺寸剩余个数,
  #       },
  #     ]
  #   }
  #
  # ===== complete
  # ===== JSON
  #
  #   {
  #     "products" : [
  #       {
  #         "id" : ID,
  #         "label" : 备注,
  #         "prefix" : 前缀,
  #         "name" : 名称,
  #         "description" : 描述,
  #         "major_pic" : 主图片,
  #         "model_pic" : 模特图片,
  #         "detail_pic" : 详情图片,
  #         "spec_pic" : 规格图片,
  #         "fitting_pic" : 试衣图片,
  #         "download_pic" : 下载图片,
  #         "background" : 背景图片,
  #         "color_pic" : 颜色图片,
  #         "color_name" : 颜色名称,
  #         "match_pic" : 搭配图片,
  #         "percent_text" : 折扣说明,
  #         "image_id" : 主图片,
  #         "video_id" : 视频ID,
  #         "target" : 对象，可以为[男 女 中性 儿童]之一,
  #         "thickness" : 厚度，可以为[薄 适中 厚 加厚]之一,
  #         "elasticity" : 弹力，可以为%w[无弹 微弹 中弹 强弹]之一,
  #         "pliability" : 柔软，可以为%w[柔软 适中 偏硬]之一,
  #         "recommend" : 推荐，可以为{ 'featured' => '精选', 'newest' => '最新', 'hot' => '热门' } 之一,
  #         "color" : 颜色，可以为[红 粉 紫 蓝 绿 黄 橙 棕 灰 黑 白 银 彩]之一,
  #         "price" : 市场价,
  #         "discount" : 销售价,
  #         "minimum_price" : 最低价,
  #         "original_price" : 原始价,
  #         "point" : 积分,
  #         "zoom" : 缩放,
  #         "extra_description" : 旗舰店描述,
  #         "extra_pic" : 旗舰店图片,
  #         "origins" : 产地列表,
  #         "measure_table" : 尺寸表,
  #         "measure_suggestion" : 尺寸建议,
  #         "measure_style" : 尺寸款型,
  #         "measure_description" : 尺寸描述,
  #         "created_at" : 创建时间,
  #         "updated_at" : 更新时间,
  #         "sell_current" : 当前销售,
  #         "unsold_count" : 未出售数量,
  #         "measures_unsold_count" : 尺寸剩余个数,
  #         "images" : [
  #           {
  #             "id" : 图片id,
  #             "large" : 大图,
  #             "description" : 描述,
  #             "sequence" : 顺序,
  #           },
  #         ],
  #         "operation_images" : [
  #           {
  #             "id" : 运营图片id,
  #             "pic" : 图片,
  #             "sequence" : 顺序,
  #           },
  #         ],
  #         "videos" : [
  #           {
  #             "id" : 视频ID,
  #             "mp4" : mp4文件路径,
  #             "flv" : flv文件路径,
  #             "swf" : swf文件路径,
  #             "hd" : 高清,
  #             "description" : 描述,
  #             "has_audio" : 声音?,
  #           },
  #         ],
  #         "mall" : {
  #           "id" : 商城ID,
  #           "name" : 名称,
  #         },
  #         "category1" : {
  #           "id" : 一级分类ID,
  #           "name" : 名称,
  #           "description" : 描述,
  #           "measures" : 尺码列表，用逗号分开,
  #           "ranges" : 价格区间，用英文逗号分隔,
  #         },
  #         "category2" : {
  #           "id" : 一级分类ID,
  #           "name" : 名称,
  #           "description" : 描述,
  #           "pic" : 图片,
  #           "measures" : 尺码列表，用逗号分开,
  #           "ranges" : 价格区间，用英文逗号分隔,
  #           "measure_pic" : 尺寸图,
  #           "contrast_pic" : 对照图片,
  #           "measure_properties" : 尺寸属性,
  #           "bust_offset" : 胸围偏移,
  #           "bust_error" : 胸围误差,
  #           "waistline_offset" : 腰围偏移,
  #           "waistline_error" : 腰围误差,
  #           "hip_offset" : 臀围偏移,
  #           "hip_error" : 臀围误差,
  #           "shoulder_offset" : 肩宽偏移,
  #           "shoulder_error" : 肩宽误差,
  #           "arm_offset" : 臂长偏移,
  #           "arm_error" : 臂长误差,
  #           "leg_offset" : 腿长偏移,
  #           "leg_error" : 腿长误差,
  #         },
  #         "category3" : {
  #           "id" : 三级分类ID,
  #           "name" : 名称,
  #         },
  #         "brand" : {
  #           "id" : 品牌ID,
  #           "name" : 英文名,
  #           "chinese" : 中文名,
  #           "abbreviation" : 缩写,
  #           "initial" : 首字母,
  #           "link" : 圣经链接,
  #           "description" : 描述,
  #           "pic" : 图片,
  #           "swf" : swf文件,
  #           "recommend" : 推荐,
  #           "images" : [
  #             {
  #               "id" : 品牌图片id,
  #               "pic" : 图片,
  #               "sequence" : 顺序,
  #             },
  #           ],
  #         },
  #         "multibuy": {
  #           "id": ID,
  #           "name": 名称,
  #           "percent_for_2": 2件折扣,
  #           "percent_for_3": 3件折扣,
  #           "percent_for_4": 4件以上折扣,
  #         }
  #         "values" : [
  #           {
  #             "id" : 属性值ID,
  #             "attribute_name" : 属性名,
  #             "content" : 内容,
  #           },
  #         ],
  #         "relate_products" : [
  #           {
  #             "id" : 相关产品ID,
  #             "name" : 名称,
  #             "color_name" : 颜色,
  #             "color_pic" : 颜色图片,
  #           },
  #         "match_products" : [
  #           {
  #             "id" : 搭配产品ID,
  #             "name" : 名称,
  #             "major_pic" : 图片,
  #           },
  #         ],
  #       },
  #     ]
  #   }
  #
  # ==== Instructions
  #
  # 读取列表页：
  #   GET /shop/products.json?response=simple&per_page=5000
  #   GET /shop/products.json?response=summary&ids=1,2,3
  # 读取单品页：
  #   GET /shop/products/:id.json
  #
  def index
    ids = params[:ids]
    ids = ids.split(',') if ids.is_a?(String)
    ids = ids.values if ids.is_a?(Hash)
    ids = ids.map(&:to_i).uniq if ids
    unless ids
      params[:where] ||= {}
      params[:order] ||= {}
      params[:where][:brand_id] ||= params[:where_brand_id] if params[:where_brand_id]
      params[:where][:category1_id] ||= params[:where_category1_id] if params[:where_category1_id]
      params[:where][:category2_id] ||= params[:where_category2_id] if params[:where_category2_id]
      case params[:name]
        when 'latest';
          params[:order][:arrived_at] = 'desc'
        when /men|women/;
          params[:where][:target] = params[:name]
      end
      !params[:keyword].blank? && (synonym = Shop::Synonym.active.published.find_by_name(params[:keyword].to_s.strip)) && (options = %w[brand_id category1_id category2_id target color].map { |k| (v = synonym.send(k)).blank? ? nil : {k => v} }.compact.inject(&:merge)) && options.map { |k, v| params[:where][k].blank? || params[:where][k] == v.to_s }.inject(&:&) && options.map { |k, v| params[:where][k] = v } && (params[:keyword] = nil)
      page = (params[:page] || 1).to_i
      per_page = (params[:per_page] || 70).to_i
      params[:where][:target] = {'men' => '男', 'women' => '女', 'nogender' => '无性别', 'children' => '儿童', }[params[:where][:target]] || params[:where][:target] if params[:where][:target]
      params[:where][:target].map! { |t| {'men' => '男', 'women' => '女', 'nogender' => '无性别', 'children' => '儿童', }[t] || t } if params[:where][:target].is_a?(Array)
      params[:where][:color] = Shop::Product::COLORS.map { |k, v| {v => k} }.inject(&:merge)[params[:where][:color]] || params[:where][:color] if params[:where][:color]
      params[:where][:color].map! { |c| Shop::Product::COLORS.map { |k, v| {v => k} }.inject(&:merge)[c] || c } if params[:where][:color].is_a?(Array)
      params[:where][:unsold_count] = {:gteq => 0} if (params[:format] || 'html') == 'html' && !params[:where][:unsold_count]
      engine = params[:engine] || (Rails.env == 'production' ? 'solr' : 'database')
    end
    if ids
      @products = Shop::Product.active.published.where("id IN (#{ids.join(',')})")
    elsif engine == 'solr'
      # options = [["wt", "json"], ["indent", "on"], ["fl", "id"], ["start", (page-1)*per_page], ["rows", per_page], ["fq", "active:true"], ["fq", "published:true"], ["forceElevation", true]]
      options = [["wt", "json"], ["indent", "on"], ["fl", "id"], ["start", (page-1)*per_page], ["rows", per_page], ["forceElevation", true]]
      # options << ["fq", "mall_id:1"] unless params[:where][:mall_id]
      options << ["fq", (params[:where][:target].to_sz + [(params[:where][:target].to_sz & %w[男 女]).empty? ? nil : '中性']).compact.uniq.map { |t| "target:#{t}" }.join(' OR ')] if params[:where][:target]
      options << ["q", params[:keyword].blank? ? "*:*" : params[:keyword].to_s.strip.gsub(/[\+\-\&\|\!\(\)\{\}\[\]\^\"\~\*\?\:\\]/) { |c| "\\"+c }]
      options += (params[:values]||{}).map { |key, values| ["fq", [values].flatten.map { |value| %[values:"#{key}:#{value}"] }.join(' OR ')] }
      options += params[:where].slice(:measure, :id, :mall_id, :category1_id, :category2_id, :category3_id, :brand_id, :multibuy_id, :color, :recommend, :unsold_count, :arrived_at, :updated_at).merge(params[:where][:price] ? {:discount => params[:where][:price]} : {}).map { |f, value| value.is_a?(Hash) ? value.map { |op, v| v = v.to_s.strip.gsub(/[\+\-\&\|\!\(\)\{\}\[\]\^\"\~\*\?\:\\]/) { |c| "\\"+c }; ['fq', {'eq' => "#{f}:#{v}", 'noteq' => "-#{f}:#{v}", 'gteq' => "#{f}:[#{v} TO *]", 'lteq' => "#{f}:[* TO #{v}]", 'gt' => "-#{f}:[* TO #{v}]", 'lt' => "-#{f}:[#{v} TO *]", }[{'=' => 'eq', '<>' => 'noteq', '!=' => 'noteq', '>=' => 'gteq', '<=' => 'lteq', '>' => 'gt', '<' => 'lt'}[op]||op]] } : [['fq', value.to_sz.map { |v| "#{f}:#{v.to_s.strip.gsub(/[\+\-\&\|\!\(\)\{\}\[\]\^\"\~\*\?\:\\]/) { |c| "\\"+c }}" }.join(' OR ')]] }.inject([], &:+)
      options << ["sort", (o = params[:order].slice(:percent, :scarcity, :readings_count, :point, :arrived_at, :updated_at).merge(params[:order][:price] ? {:discount => params[:order][:price]} : {}).merge(params[:order][:created_at] ? {:arrived_at => params[:order][:created_at]} : {}).map { |k, v| "#{k} #{v.to_s.strip.gsub(/[\+\-\&\|\!\(\)\{\}\[\]\^\"\~\*\?\:\\]/) { |c| "\\"+c }}" }.join(',')) && !o.blank? ? o : "published_at desc"]
      options += %w[brand_id category1_id category2_id category3_id target color measure].keep_if { |field| params[:where][field].blank? }.map { |field| ["facet.field", field] } + [["facet", "true"], ["facet.sort", "count"], ["facet.mincount", 1], ["facet.limit", 100], ["facet.field", "searchable_values"], ["f.searchable_values.facet.limit", 10000]] + (params[:where][:price] ? [] : [["facet.range", "discount"], ["f.discount.facet.range.start", 0], ["f.discount.facet.range.end", 1000000], ["f.discount.facet.range.gap", 2000]]) # if page == 1
      if params[:order].slice(:percent, :scarcity, :readings_count, :arrived_at, :updated_at, :created_at, :price).blank? && params[:where].slice(:recommend, :mall_id).blank?
        # && (@sticky = Sticky.active.published.scoped(:conditions => %w[brand_id category1_id category2_id category3_id target].map { |f| {f => f == 'target' ? params[:where][f].to_s : params[:where][f].blank? || params[:where][f].is_a?(Array) ? nil : params[:where][f].to_i} }.inject(&:merge)).first)
        # sticky_product_ids = @sticky.product_ids.to_s.scan(/\d+/).map(&:to_i).uniq
        # bottom_product_ids = @sticky.bottom_product_ids.to_s.scan(/\d+/).map(&:to_i).uniq - sticky_product_ids
        # options << ["elevateIds", sticky_product_ids[0..199].join(','), "enableElevation", true] if sticky_product_ids.present?
        options << ["fq", "name:#{params[:keyword]}"] if params[:keyword].present?
        # options << ["excludeIds", bottom_product_ids[0..99].join(',')] if bottom_product_ids.present?
      end
      logger.info url = "http://#{SOLR_CONFIG['host']}:#{SOLR_CONFIG['port']}/solr/product/select?#{options.map { |k, v| "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}" }.join('&')}"
      data = JSON.parse(Timeout::timeout(10) { HTTParty.get(url) }) rescue {}
      @product_ids = data['response']['docs'].map { |doc| doc['id'].to_i }
      @products_count = data['response']['numFound'].to_i
      # @sticky_xml = @sticky.images.blank? ? @sticky.xml : @sticky.assign_options({:only => [].freeze, :include => {:images => {:only => [:id, :name, :pic, :url, :dimension_x, :dimension_y].freeze, :methods => [:order].freeze, :objects => {}.freeze, }.freeze, }.freeze, }.freeze).to_xml(:root => 'response', :skip_instruct => true, :skip_types => true, :dasherize => false) if @sticky
      if data['facet_counts']
        @products_facet = data['facet_counts']['facet_fields'].slice(*%w[brand_id category1_id category2_id category3_id target color measure]).map { |field, values| {field.to_sym => values.each_slice(2).map { |value, count| {:value => %w[brand_id category1_id category2_id category3_id].include?(field) ? value.to_i : value, :count => count} }} }.inject({}, &:merge)
        category = (id = params[:where][:category1_id]) && (category = Shop::Category.find_by_id(id)) || (id = params[:where][:category2_id]) && (category = Shop::Category.find_by_id(id)) || Shop::Category.find_by_id(1) || Shop::Category.new
        @products_facet[:measure] = @products_facet[:measure] && @products_facet[:measure].reject { |p| !(category.measures && category.measures.split(',').include?(p[:value])) }
        attribute_names = category.inheritance_attributes.keep_if(&:searchable?).map(&:name)
        @products_facet.merge!(:values => data['facet_counts']['facet_fields']["searchable_values"].each_slice(2).map { |value, count| {:name => value.split(':')[0], :value => value.split(':')[1], :count => count} }.group_by { |p| p[:name] }.sort_by { |name, group| name.to_s }.keep_if { |name, group| attribute_names.include?(name) }.map { |name, group| {:name => name, :options => group.map { |v| v.slice(:value, :count) }} })
        @products_facet.merge!(:price => (p = data["facet_counts"]["facet_ranges"] && data["facet_counts"]["facet_ranges"]["discount"]) && p["counts"].each_slice(2).map { |value, count| {:value => [value.to_i, value.to_i+p["gap"].to_i-1], :count => count} } || [])
        @products_facet = @products_facet.reject { |k, v| v.blank? } || {}
        @filters = @products_facet.slice(*%w[brand_id category1_id category2_id category3_id target color measure].map(&:to_sym)).map { |field, values| {field => (values||[]).map { |v| v[:value] }} }.inject({}, &:merge).merge(:values => (@products_facet[:values]||[]).map { |value| {value[:name] => value[:options].map { |option| option[:value] }} }.inject({}, &:merge))
        %w[brand_id category1_id category2_id category3_id target color measure].each { |field| @filters[field.to_sym] ||= [] }
        @filters.merge!(:maximum_price => (@products_facet[:price]||[]).map { |p| p[:value] }.flatten.max || 0, :minimum_price => (@products_facet[:price]||[]).map { |p| p[:value] }.flatten.min || 0)
        @filters[:measures] = @filters.delete(:measure) unless @filters[:measure].blank?
      end
    elsif engine == 'database'
      @products = Shop::Product.active.published
      # @products = @products.where(mall_id: 1) unless params[:where][:mall_id]
      @products = @products.where((params[:where][:target].to_sz + [(params[:where][:target].to_sz & %w[男 女]).empty? ? nil : '中性']).compact.uniq.map { |t| "target = #{Shop::Product.sanitize(t)}" }.join(' OR ')) if params[:where][:target]
      @products = @products.where(params[:where][:measure].to_sz.map { |m| %[measures_unsold_count LIKE #{Shop::Product.sanitize(%[%"#{m}"%])} AND measures_unsold_count NOT LIKE #{Shop::Product.sanitize(%[%"#{m}":0%])}] }.join(' OR ')) if params[:where][:measure]
      @products = @products.where((keyword = params[:keyword].to_s.strip.gsub(/\s+/, "%")) && !keyword.blank? && ["name LIKE ? OR prefix LIKE ? OR label LIKE ?", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%"])
      @products = @products.joins(params[:values].each_with_index.map { |v, i| %[JOIN shop_values shop_values_#{i} ON shop_values_#{i}.product_id = shop_products.id AND shop_values_#{i}.active = TRUE AND (#{v[1].to_sz.map { |c| %[shop_values_#{i}.attribute_name = #{Shop::Value.sanitize(v[0])} AND shop_values_#{i}.content = #{Shop::Value.sanitize(c)}] }.join(' OR ')})] }.join(' ')) if params[:values]
      @products = @products._where((params[:where] || {}).slice(:id, :category1_id, :category2_id, :category3_id, :brand_id, :multibuy_id, :color, :recommend, :unsold_count, :arrived_at, :updated_at).merge(params[:where][:price] ? {:discount => params[:where][:price]} : {}))
      @products_count = @products.count
      if 1 # >= params[:page].to_i
        @products_facet = %w[category1_id category2_id category3_id brand_id color target].map(&:to_sym).map { |field| {field => @products.select("#{Shop::Product.quoted_table_name}.#{field} AS field, COUNT(*) AS cnt").group("#{Shop::Product.quoted_table_name}.#{field}").order("cnt DESC").limit(100).map { |p| {:value => p.field, :count => p.cnt.to_i} }.sort_by { |p| p[:count] }.reverse} }.inject(&:merge)
        category = (id = params[:where][:category1_id]) && (category = Shop::Category.find_by_id(id)) || (id = params[:where][:category2_id]) && (category = Shop::Category.find_by_id(id)) || Shop::Category.find_by_id(1) || Shop::Category.new
        @products_facet.merge!(:price => (ranges = category.ranges.to_s.split(',').map(&:to_i)) && (0..ranges.size-1).map { |i| a=i==0 ? 0 : ranges[i-1]; b=ranges[i]; (count = @products.where("discount >= ? AND discount <= ?", a, b).count) && count > 0 ? {:value => [a, b], :count => count} : nil }.compact)
        @products_facet.merge!(:measure => @products.select(:measures_unsold_count).where("measures_unsold_count IS NOT NULL").map { |p| (ActiveSupport::JSON.decode(p.measures_unsold_count) rescue {}).reject { |k, v| v == 0 }.keys.reject { |m| !category.measures.split(',').include?(m) } }.flatten.compact.reject(&:blank?).group_by(&:to_s).map { |value, group| {:value => value, :count => group.size} }.sort_by { |p| p[:count] }.reverse[0..99]) unless category.measures.blank?
        @products_facet.merge!(:values => category.inheritance_attributes.keep_if(&:searchable?).map { |attribute| {:name => attribute.name, :options => @products.select("#{Shop::Value.quoted_table_name}.content, COUNT(*) AS cnt").joins("JOIN #{Shop::Value.quoted_table_name} ON #{Shop::Value.quoted_table_name}.product_id = #{Shop::Product.quoted_table_name}.id").where("#{Shop::Value.quoted_table_name}.attribute_id = ? AND #{Shop::Value.quoted_table_name}.active = ?", attribute.id, true).group("#{Shop::Value.quoted_table_name}.content").order("cnt DESC").limit(100).map { |p| {:value => p.content, :count => p.cnt.to_i} }.sort_by { |p| p[:count] }.reverse}.delete_if { |k, v| v.blank? } })
        @products_facet = @products_facet.reject { |k, v| v.blank? } || {}
        @filters = @products_facet.slice(*%w[brand_id category1_id category2_id category3_id target color measure].map(&:to_sym)).map { |field, values| {field => (values||[]).map { |v| v[:value] }} }.inject({}, &:merge).merge(:values => (@products_facet[:values]||[]).map { |value| {value[:name] => (value[:options]||[]).map { |option| option[:value] }} }.inject({}, &:merge))
        %w[brand_id category1_id category2_id category3_id target color measure].each { |field| @filters[field.to_sym] ||= [] }
        @filters.merge!(:maximum_price => (@products_facet[:price]||[]).map { |p| p[:value] }.flatten.max || 0, :minimum_price => (@products_facet[:price]||[]).map { |p| p[:value] }.flatten.min || 0)
        @filters[:measures] = @filters.delete(:measure) unless @filters[:measure].blank?
      end
      @products = @products._order((o = (params[:order]||{}).slice(:percent, :scarcity, :readings_count, :point, :arrived_at, :updated_at).merge(params[:order][:price] ? {:discount => params[:order][:price]} : {}).merge(params[:order][:created_at] ? {:arrived_at => params[:order][:created_at]} : {}).map { |k, v| {"#{Shop::Product.quoted_table_name}.#{k}" => v} }.inject({}, &:merge)) && !o.empty? ? o : {"#{Shop::Product.quoted_table_name}.published_at" => 'desc'})
      @product_ids = @products.select("#{Shop::Product.quoted_table_name}.id").limit(per_page).offset((page-1)*per_page).map(&:id)

      # if @product_ids
      # 	if params[:order].slice(:percent, :scarcity, :readings_count, :arrived_at, :updated_at, :created_at, :price).blank? && params[:where].slice(:recommend, :mall_id).blank? && (@sticky = Sticky.active.published.scoped(:conditions => %w[brand_id category1_id category2_id category3_id target].map{|f| { f => f == 'target' ? params[:where][f].to_s : params[:where][f].blank? || params[:where][f].is_a?(Array) ? nil : params[:where][f].to_i } }.inject(&:merge)).first)
      # 		sticky_product_ids = @sticky.sellable_product_ids
      # 		bottom_product_ids = @sticky.sellable_bottom_product_ids - sticky_product_ids
      # 		@product_ids = (sticky_product_ids & @product_ids) + (@product_ids - sticky_product_ids - bottom_product_ids) + (bottom_product_ids & @product_ids)
      # 		@sticky_xml = @sticky.images.blank? ? @sticky.xml : @sticky.assign_options({ :only => [].freeze, :include => { :images => { :only => [ :id, :name, :pic, :url, :dimension_x, :dimension_y ].freeze, :methods => [ :order ].freeze, :objects => {}.freeze, }.freeze, }.freeze, }.freeze).to_xml(:root => 'response', :skip_instruct => true, :skip_types => true, :dasherize => false)
      # 	end
      # end
    end
    if @product_ids
      product_ids = ((@product_ids||[])+['NULL']).join(',')
      @products = Shop::Product.where(["#{Shop::Product.quoted_table_name}.id IN (#{product_ids})"]).order("FIELD(id,#{product_ids})")
      if params[:response] == 'simple'
        @products = @products.select('id,discount,updated_at')
      end
    end

    respond_to do |format|
      format.html
      format.spider
      format.rss
      format.xml {
        case
          when params[:_format] == :xml && params[:response] == 'summary' && (@ids = ids)
            render :action => 'index_summary.xml', :layout => false, :content_type => Mime::XML.to_s
          when params[:format] == :json && params[:response] == 'summary' && (@ids = ids)
            render :action => 'index_summary.json', :layout => false, :content_type => Mime::JSON.to_s
          when params[:_format] == :xml && params[:response] == 'simple'
            render :action => 'index_simple.xml', :layout => false, :content_type => Mime::XML.to_s
          when params[:_format] == :json && params[:response] == 'simple'
            render :action => 'index_simple.json', :layout => false, :content_type => Mime::JSON.to_s
          when %w[simple summary slim].include?(params[:response]) || params[:response] == 'complete' && ids && ids.size == 1
            @data = {products: @products.includes(:brand).assign_options(only: %w[id discount major_pic], include: {brand: {only: %[name]}})} if params[:response] == 'slim'
            @data ||= {'products' => @products.to_a.assign_options(Shop::Product.xml_options_for(params[:response])), 'products_count' => @products_count, 'products_facet' => @products_facet.to_json, 'filters' => @filters.to_json, 'sticky_xml' => @sticky_xml, 'sticky' => @sticky}
        end
      }
    end
  end

  def view_units
    respond_to do |format|
      format.html { head :ok }
    end
  end
#
  # == 查看
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /sh  op/prodcts/:id
  #
  # ==== Parameters
  #
  # id :: 产品ID
  #
  # === Response
  #
  # 请见 index 接口的complete格式
  #
  # ==== JSON
  #
  # ==== XML
  #
  # ==== YAML
  #
  def show
    @product = Shop::Product.acquire(params[:id])

    unless @product.published
      not_found_source!
      return
    end

    respond_to do |format|
      format.html { @enable_lazyload = false }
      format.spider
      format.xml { @data = {'product' => @product.assign_options(Shop::Product.new_xml_options)} }
    end
  end

  def comments
    @product = Shop::Product.acquire(params[:id])
    @comments = @product.comments.page(params[:page]).per(params[:per_page]||10)
    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.spider
      format.xml { @data = {'comments' => @comments.to_json} }
    end
  end

  ##
  # == 最新商品
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/products/latest_products
  #
  # ==== Parameters
  #
  # === Response
  #
  # 原有 http://www.weimall.com/data/common/files/162/get xml基础上 添加simple格式的<products>节点
  #
  # ==== JSON
  #   {
  #     "preview" : [
  #     ],
  #     "recommend" : [
  #     ],
  #     "products" : [
  #       {
  #         "id" : ID,
  #         "discount" : 销售价,
  #         "zoom" : 缩放,
  #         "updated_at" : 更新时间,
  #       },
  #     ],
  #     "filters" : 筛选,
  #
  #
  #
  # ==== XML
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <preview>
  #       <pics type="Array">
  #         <pic>
  #           <img>图片地址</img>
  #           <link>链接</link>
  #         </pic>
  #       </pics>
  #     </preview>
  #     <recommend>
  #       <medium>
  #         <products>
  #           <product>
  #           </product>
  #         </products>
  #       </medium>
  #     </recommend>
  #     <products type="Array">
  #       <product type="Shop::Product">
  #         <id type="integer">ID</id>
  #         <discount type="integer">销售价</discount>
  #         <zoom type="integer">缩放</zoom>
  #         <updated_at type="datetime">更新时间</updated_at>
  #       </product>
  #     </products>
  #     <filters>筛选</filters>
  #   </response>
  #
  # ==== YAML
  #
  def latest_products
    @xml = Nokogiri::XML.parse(Timeout::timeout(10) { HTTParty.get("http://www.weimall.com/data/common/files/162/get").body })
    @products = @xml.css('categories').remove.css('category').map do |category|
      amount = category.css('amount').css('sum,male,female').map { |child| {child.name => child.try(:text)} }.inject(:merge)
      category_products = Shop::Product.active.published.where(category1_id: category.css('category1_id').try(:text)).order('arrived_at DESC')
      top_ids = category.css('top_ids').try(:text).to_s.scan(/\d+/)
      if amount.try(:[], 'male').present? || amount.try(:[], 'female').present?
        {'female' => '女', 'male' => '男'}.map do |k, v|
          sex_products_group = category_products.where(target: v).limit(amount.try(:[], k))
          if top_ids.present?
            sex_top_group = Shop::Product.active.published.where(id: top_ids).order("FIELD(id,#{top_ids.join(',')})").group_by(&:target)
            sex_products_group = sex_products_group.unshift(*sex_top_group.try(:[], v).to_sz).uniq.take(amount.try(:[], k).to_i)
          end
          sex_products_group
        end.inject(&:+)
      elsif amount.try(:[], 'sum').present?
        sum_products = category_products.limit(amount.try(:[], 'sum'))
        sum_products = sum_products.unshift(*Shop::Product.active.published.where(id: top_ids).order("FIELD(id,#{top_ids.join(',')})")).uniq.take(amount.try(:[], 'sum').to_i) if top_ids.present?
        sum_products
      end
    end

    if (@products = @products.to_a.compact.flatten).present?
      @filters = Nokogiri::XML.parse(Timeout::timeout(10) { HTTParty.get("http://www.weimall.com/shop/products.xml", query: {id: @products.map(&:id), response: 'simple'}).body }).css('filters')
      @products = Nokogiri::XML.parse(@products.assign_options(Shop::Product.xml_options_for('simple')).to_xml(:root => 'product', :dasherize => false, :skip_types => true)).at_css('product')
      @products.name = 'products'
      @xml.at_css('response').add_child(@products)
      @xml.at_css('response').add_child(@filters)
    end

    respond_to do |format|
      format.xml { @data = @xml }
    end
  end

  def help
    @enable_lazyload = false
  end

  ##
  # == 360平台列表
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/products/mall360
  #
  # ==== Parameters
  #
  # page :: 页数
  # per_page :: 每页个数
  #
  # === Response
  #
  # ==== CSV
  #
  def mall360
    @products = simple_products

    respond_to do |format|
      format.html
      format.xml { @data = {'products' => @products} }
      format.csv { render :text => %[#{([%w[bid,outer_id,bc_id,brand_name,brand_ename,brand_alias,item_name,item_alias,product_code,sale_title,recommend_des,item_summary,item_des,market_price,sale_price,main_props,other_props,pic_url,item_image,is_offergift,offergift,peoplegroup,is_new,has_storage,has_invoice,free_delivery,cash_on_delivery,reserve,reserve_des,has_certificate,sale_num,time_on_market,time_on_sale,after_service,source_url]] + ::ActiveRecord::Base.connection.execute("SELECT CONCAT_WS(',', COALESCE(1005), product.id, product.category2_id, brand.chinese, brand.name, COALESCE(''), product.name, brand.abbreviation, product.identifier, product.name, IF(product.discount>0&&product.price>0,IF(product.discount=product.price,'',TRUNCATE((product.discount*10)/product.price,1)),''), COALESCE(''), COALESCE(''), product.price, product.discount, COALESCE(''), COALESCE(''), CONCAT('http://#{[HOSTS['image']].flatten.first}',product.major_pic), CONCAT('http://#{[HOSTS['image']].flatten.first}',product.major_pic), COALESCE('FALSE'), COALESCE(''), CASE product.target WHEN '女' THEN 1 WHEN '男' THEN 2 ELSE 99 END, COALESCE('TRUE'), IF(product.sell_current=0,'TRUE','FALSE'), COALESCE('TRUE'), COALESCE('TRUE'), COALESCE('TRUE'), COALESCE('TRUE'), COALESCE(''), COALESCE('TRUE'), COALESCE(''), COALESCE(''), DATE_FORMAT(product.published_at,'%Y-%m-%d %k:%i:%s'), COALESCE(''), CONCAT('http://360.weimall.com/shop/products/',product.id)) FROM #{Shop::Product.quoted_table_name} AS product, #{Shop::Brand.quoted_table_name} AS brand  WHERE mall_id = 1 AND product.published = 1 AND product.active = 1 AND product.brand_id = brand.id ORDER BY product.published_at DESC LIMIT #{(params[:per_page] || 50).to_i}").to_sz).join("\n")}] }
    end
  end

  ##
  # == 360平台库存
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/products/mall360storage
  #
  # ==== Parameters
  #
  # page :: 页数
  # per_page :: 每页个数
  #
  # === Response
  #
  # ==== CSV
  #
  def mall360storage
    @products = simple_products

    respond_to do |format|
      format.html
      format.xml { @data = {'products' => @products} }
      format.csv { render :text => generate_csv([%w[bid outer_id sale_price storage]] + @products.map { |product| [1005, product.id, product.discount, product.unsold_count.to_i == 0 ? 0 : 1] }) }
    end
  end

  ##
  # == 百度微购产品接口全量增量索引界面
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/products/baidu_index
  #
  # ==== Parameters
  #
  # per_page :: 每页个数
  # outer_id :: 页数
  #
  # === Response
  #
  # === Response
  #
  # ==== XML
  #
  #  <?xml version="1.0" encoding="UTF-8"?>
  #  <root>
  #    <version>feed 数据格式的版本号</version>
  #    <modified>数据文件最近修改时间</modified>
  #    <seller_id>商家名称</seller_id>
  #    <total>商家全量推送过来的所有商品数量</total>
  #    <dir>商家数据包所在的目录地址</dir>
  #    <item_ids>
  #      <outer_id action="upload">1</outer_id>
  #      <outer_id action="upload">2</outer_id>
  #      <outer_id action="upload">3</outer_id>
  #      <!--全量更新只允许 upload 上架商品, 上传outer_id内容与baidu接口返回内容一致
  #    </item_ids>
  #  </root>
  #
  #
  def baidu_index
    products = Shop::Product.published.active.where(mall_id: 1).where(params[:increment].present? && "updated_at > ?", Time.now - 0.5.hours)
    products.count == 0 ? body = "" : body = (products.count/1000 + 1).times.map { |i| "<outer_id action='upload'>#{i+1}</outer_id>" }.join
    respond_to do |format|
      format.xml { render text: %{<?xml version="1.0" encoding="UTF-8" ?><root><version>1.0</version><modified>#{Time.now.to_s(:db)}</modified><seller_id>珀丽莱</seller_id>
										<total>#{products.count}</total><dir>#{params[:increment].present? ? 'http://baidu.weimall.com/shop/products/baidu_increment' : 'http://baidu.weimall.com/shop/products/baidu'}</dir>
										<item_ids>#{body}</item_ids></root>} }
    end
  end

  ##
  # == 百度微购产品接口
  #
  # GET /shop/products/baidu

  #
  # ==== Parameters
  #
  # outer_id :: 页数
  # per_page :: 每页个数
  # time :: 增量更新查询时间(秒)或全量查询
  #
  # === Response
  #
  # ==== XML
  #
  #  <?xml version="1.0" encoding="UTF-8"?>
  #  <items>
  #    <item>
  #      <seller_id>商家名称</seller_id>
  #      <outer_id>商家商品索引号</outer_id>
  #      <title>商品标题</title>
  #      <product_id>货号 商家内部使用的产品标志 id</product_id>
  #      <available>0/1 是否缺货</available>
  #      <price>商品价格</price>
  #      <discount>打折信息
  #        <dprice>折扣价 单位:元,精确到两位小数</dprice>
  #        <ddesc>打折信息描述</ddesc>
  #      </discount>
  #      <desc>商品简单描述</desc>
  #      <selforopen>自营商品或平台 商家商品,值为 0 或 1。0 代表自营商品,1 代表平台商家商 品。</selforopen>
  #      <business_name>该商品所属第三方具体商家名称;条件:如果 selforopen 为 1,则此字段必填</business_name>
  #      <brand>商品品牌</brand>
  #      <tags>商品标签</tags>
  #      <image>商品主图地址,图片类型:jpg、jpeg、png,不支持 gif;尽量是高清近景大图</image>
  #      <href>商品链接绝对地址</href>
  #      <sale_volume>销量数字,精确到整数</sale_volume>
  #      <comment_count>评论数量,该商品的总评论数</comment_count>
  #      <saled_score>商品评分 若无法提供标签内为空</saled_score>
  #      <bread_crumb>面包屑。格式:生鲜食品/新鲜水果,用/符号隔开。即:此商品通过你网站访新鲜水果下的一个产品。除首页网站的“你的位 置”中相关信息</bread_crumb>
  #    </item>
  #  </items>
  #
  #
  def baidu
    outer_id = (params[:id] || 1).to_i
    per_page = (params[:per_page] || 1000).to_i
    sql = <<-SQL_HEAD
			SELECT  CONCAT_WS('', '<item><seller_id>珀丽莱</seller_id><outer_id>', #{outer_id} ,'</outer_id><title>', REPLACE(REPLACE(REPLACE(p.name, '&','&amp;'), '>', '&gt;'), '<', '&lt;'),
				'</title><product_id>', p.id, '</product_id><available>1</available><price>', p.price,
				'</price><discount><dprice>', p.discount, '</dprice></discount><desc>', REPLACE(REPLACE(REPLACE(Left(p.description, 500), '&','&amp;'), '>', '&gt;'), '<', '&lt;'),
				'</desc><selforopen>0</selforopen><business_name></business_name><brand>', REPLACE(REPLACE(REPLACE(Left(brand.name, 500), '&','&amp;'), '>', '&gt;'), '<', '&lt;'),
				'</brand><tags></tags><image>http://#{[HOSTS["image"]].flatten.first}', p.major_pic,
				'</image><href>http://baidu.weimall.com/shop/products/', p.id,
				'</href><sale_volume>', p.sold_count, '</sale_volume>',
				'</item>' )
			FROM shop_products p, shop_brands brand
			WHERE p.published = TRUE AND p.active = TRUE AND p.mall_id = TRUE AND p.brand_id = brand.id
			LIMIT #{(outer_id-1)*per_page || 0}, #{per_page}
    SQL_HEAD

    xml_body = <<-HEAD
			<?xml version="1.0" encoding="UTF-8" ?><items>
				#{ ::ActiveRecord::Base.connection.execute(sql).to_a.join }
			</items>
    HEAD

    respond_to do |format|
      format.xml { render text: xml_body.strip }
    end
  end

  def baidu_increment
    outer_id = (params[:id] || 1).to_i
    per_page = (params[:per_page] || 1000).to_i
    sql = <<-SQL_HEAD
			SELECT  CONCAT_WS('', '<item><seller_id>珀丽莱</seller_id><outer_id>', #{outer_id} ,'</outer_id><title>', REPLACE(REPLACE(REPLACE(p.name, '&','&amp;'), '>', '&gt;'), '<', '&lt;'),
				'</title><product_id>', p.id, '</product_id><available>1</available><price>', p.price,
				'</price><discount><dprice>', p.discount, '</dprice></discount><desc>', REPLACE(REPLACE(REPLACE(Left(p.description, 500), '&','&amp;'), '>', '&gt;'), '<', '&lt;'),
				'</desc><selforopen>0</selforopen><business_name></business_name><brand>', REPLACE(REPLACE(REPLACE(Left(brand.name, 500), '&','&amp;'), '>', '&gt;'), '<', '&lt;'),
				'</brand><tags></tags><image>http://#{[HOSTS["image"]].flatten.first}', p.major_pic,
				'</image><href>http://baidu.weimall.com/shop/products/', p.id,
				'</href><sale_volume>', p.sold_count, '</sale_volume>',
				'</item>' )
			FROM shop_products p, shop_brands brand
			WHERE p.published = TRUE AND p.active = TRUE AND p.mall_id = TRUE AND p.brand_id = brand.id AND p.updated_at > (NOW()-INTERVAL 0.5 HOUR)
			LIMIT #{(outer_id-1)*per_page || 0}, #{per_page}
    SQL_HEAD

    xml_body = <<-HEAD
			<?xml version="1.0" encoding="UTF-8" ?><items>
				#{ ::ActiveRecord::Base.connection.execute(sql).to_a.join }
			</items>
    HEAD

    respond_to do |format|
      format.xml { render text: xml_body.strip }
    end
  end

  ##
  # == 搜狗购物搜索产品索引页面
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/products/sogou_index
  #
  # ==== Parameters
  #
  # per_page :: 每页个数
  # time :: 增量更新查询时间(秒)或 全量查询
  #
  # === Response
  #
  # === Response
  #
  # ==== XML
  #
  #  <?xml version="1.0" encoding="UTF-8"?>
  #    <sitemapindex>
  #      <sitemap>
  #        <loc>接口地址</loc>
  #      </sitemap>
  #    </sitemapindex>
  #
  #
  def sogou_index
    per_page = (params[:per_page] || 8000).to_i
    products = Shop::Product.published.active.where(mall_id: 1).where(params[:time].present? && "updated_at > NOW()-?", params[:time].to_i)
    body = (products.count/per_page + 1).times.map { |i| "<sitemap><loc>http://#{HOSTS['dynamic']}/shop/products/sogou.xml?page=#{i+1}#{params[:time] && "&amp;time=#{params[:time].to_i}"}#{per_page && "&amp;per_page=#{per_page}"}</loc></sitemap>" }.join
    respond_to do |format|
      format.html
      format.xml { render :text => %{<?xml version="1.0" encoding="UTF-8" ?><sitemapindex>#{body}</sitemapindex> } }
    end
  end

  ##
  # == 搜狗购物搜索产品接口
  #
  # GET /shop/products/sogou
  #
  # ==== Parameters
  #
  # page :: 页数
  # per_page :: 每页个数
  # time :: 增量更新查询时间(秒)或全量查询
  #
  # === Response
  #
  # ==== XML
  #
  #  <?xml version="1.0" encoding="UTF-8"?>
  #    <shopping>
  #      <update_timestamp>时间戳</update_timestamp>
  #      <type>标记为增量更新还是全量更新，可填写值包括all_goods或increment_goods</type>
  #      <item>
  #        <update_timestamp>时间戳</update_timestamp>
  #        <item_id>ID</item_id>
  #        <action>标记更新还是删除可填写值包括upload或delete</action>
  #        <url>商品URL</url>
  #        <name>商品名</name>
  #        <price>商品售价</price>
  #        <thumbnails>
  #          <thumbnail>
  #            <url>缩略图链接</url>
  #            <description>缩略图链接</description>
  #          </thumbnail>
  #        </thumbnails>
  #        <categories>
  #          <category>
  #            <name>一级分类名称</name>
  #          </category>
  #          <category>
  #            <name>二级分类名称</name>
  #          </category>
  #        </categories>
  #        <services>
  #          <service>服务保证</service>
  #          <service>7天无条件退换</service>
  #          <service>尊贵级礼盒包装</service>
  #        </services>
  #        <stock_information>
  #          <stock>
  #            <region>全国</region>
  #            <volume>1</volume>
  #          </stock>
  #        </stock_information>
  #        <saled_volume>销量</saled_volume>
  #        <saled_volume_period>销售周期 0: 累计销量</saled_volume_period>
  #      </item>
  #    </shopping>
  #
  #
  def sogou
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 8000).to_i
    sql = <<-SQL_HEAD
			SELECT  CONCAT_WS('', '<item><update_timestamp>', unix_timestamp(p.updated_at), '</update_timestamp><item_id>', p.id, '</item_id><action>upload</action>',
				'<url>http://#{HOSTS["dynamic"]}/l/445942?redirect=%2F%23subapp%3DproductGrid%26category2_id%3D', p.category2_id ,'%26popup%3DsingleProduct%26productId%3D', p.id, '</url>',
				'<name>', REPLACE(REPLACE(REPLACE(p.name, '&','&amp;'), '>', '&gt;'), '<', '&lt;') ,'</name><price>', p.discount ,'</price>',
				'<thumbnails><thumbnail><url>http://#{[HOSTS["image"]].flatten.first}', p.major_pic, '</url><description>  </description></thumbnail></thumbnails>',
				'<categories><category><name>', REPLACE(REPLACE(REPLACE(c1.name, '&','&amp;'), '>', '&gt;'), '<', '&lt;'), '</name></category>',
				'<category><name>', REPLACE(REPLACE(REPLACE(c2.name, '&','&amp;'), '>', '&gt;'), '<', '&lt;'), '</name></category></categories>',
				'<services><service>100%全球正品</service><service>7天无条件退换</service><service>尊贵级礼盒包装</service></services>',
				'<stock_information><stock><region>全国</region><volume>', p.unsold_count ,'</volume></stock></stock_information>',
				'<saled_volume>', p.sold_count ,'</saled_volume><saled_volume_period>0</saled_volume_period>',
				'</item>')
			FROM shop_products p, shop_categories c1, shop_categories c2
			WHERE p.published = TRUE AND p.active = TRUE AND p.mall_id = TRUE AND p.category1_id = c1.id AND p.category2_id = c2.id #{params[:time].present? ? "and p.updated_at > NOW()-#{params[:time].to_i}" : ''}
			LIMIT #{(page-1)*per_page || 0}, #{per_page}
    SQL_HEAD

    xml_body = <<-HEAD
			<?xml version="1.0" encoding="UTF-8" ?><shopping>
			<update_timestamp>#{Time.now.to_i}</update_timestamp>
			<type>#{params[:time].present? ? "increment_goods" : "all_goods"}</type>
				#{ ::ActiveRecord::Base.connection.execute(sql).to_a.join }
			 </shopping>
    HEAD

    respond_to do |format|
      format.html
      format.xml { render :text => xml_body.strip }
    end
  end

  ##
  # == vizury产品
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/products/vizury
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
  #   <data>
  #     <item>
  #       <id>产品ID</id>
  #       <title>产品名称</title>
  #       <cid>产品所属类别</cid>
  #       <cname>男/女/家居/东方奢侈品/每周特惠</cname>
  #       <subcat1id>产品所属一级分类id</subcat1id>
  #       <subcat1name>产品一级分类名称</subcat1name>
  #       <subcat2id>品牌id</subcat2id>
  #       <subcat2name>品牌名称</subcat2name>
  #       <newprice>当前售价</newprice>
  #       <oldprice>市场价</oldprice>
  #       <landing>产品页面url</landing>
  #       <image>产品主图片</image>
  #       <description>描述</description>
  #     <data>
  #
  def vizury
    @products = simple_products

    respond_to do |format|
      format.html
      format.xml { render :text => %[<?xml version="1.0" encoding="UTF-8" ?><data>#{::ActiveRecord::Base.connection.execute("SELECT CONCAT_WS('', COALESCE('<item>'), CONCAT('<id>', product.id, '</id>'), CONCAT('<title>', REPLACE(REPLACE(REPLACE(product.name, '&','&amp;'), '>', '&gt;'), '<', '&lt;'), '</title>'), CONCAT('<cid>', IF(product.mall_id != 20, IF(product.category1_id = 103 || product.category1_id = 203, product.category1_id, IF(product.target = '男' || product.target = '女', product.target, '女')) , 'mall'), '</cid>'), CONCAT('<cname>', IF(product.mall_id != 20, CASE product.category1_id WHEN 103 THEN '家居' WHEN 203 THEN '东方奢侈品' ELSE IF(product.target = '男' || product.target = '女', product.target, '女') END, '每周特惠'), '</cname>'), CONCAT('<subcat1id>', IF(product.mall_id != 20, IF(product.category1_id = 103 || product.category1_id = 203, product.category2_id, IF(product.target = '男' || product.target = '女', CONCAT(product.target, '_', product.category2_id), CONCAT('女', '_', product.category2_id))) , CONCAT('mall_', product.category2_id)), '</subcat1id>'), CONCAT('<subcat1name>', category2.name ,'</subcat1name>'), CONCAT('<subcat2id>', brand.id, '</subcat2id>'), CONCAT('<subcat2name>', REPLACE(REPLACE(REPLACE(brand.name, '&','&amp;'), '>', '&gt;'), '<', '&lt;'), '</subcat2name>'), CONCAT('<newprice>', product.discount, '</newprice>'), CONCAT('<oldprice>', product.price, '</oldprice>'), CONCAT('<landing>', CONCAT('http://www.weimall.com/l/438694?redirect=%2F%23%26popup%3DsingleProduct%26productId%3D', product.id), '</landing>'), CONCAT('<image>', CONCAT('http://#{[HOSTS['image']].flatten.first}', product.major_pic), '</image>'),  COALESCE('<description></description></item>')) FROM shop_products AS product, shop_brands AS brand, shop_categories AS category2 WHERE product.published = 1 AND product.active = 1 and product.brand_id = brand.id and product.category2_id = category2.id ORDER BY product.published_at DESC LIMIT #{(params[:per_page] || 50).to_i}").to_sz.join}</data>] }
    end
  end

  ##
  # == google rss feeds
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/products/google
  #
  # ==== Parameters
  #
  # page :: 页数
  # per_page :: 每页个数
  #
  # === Response
  #
  # ==== RSS
  #
  def google
    @products = simple_products

    respond_to do |format|
      format.html
      format.xml { @data = {'products' => @products} }
      format.rss { render :layout => false }
    end
  end

  ##
  # == 多个品牌的50个最新上架可售产品
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/products/brands
  #
  # ==== Parameters
  #
  # \where[brand_id][] :: 品牌ID
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <brands type="Array">
  #       <brand>
  #         <id type="integer">ID</id>
  #         <products type="Array">
  #           <product type="Shop::Product">
  #             <id type="integer">产品ID</id>
  #             <discount type="integer">折扣价</discount>
  #             <zoom type="integer">缩放</zoom>
  #             <updated_at type="datetime">更新时间</updated_at>
  #           </product>
  #         </products>
  #       </brand>
  #     </brands>
  #   </response>
  #
  # ==== JSON
  #
  # ==== YAML
  #
  def brands
    @brands = Shop::Brand.active.find(params[:where][:brand_id])
    @brands.map! { |brand| {'id' => brand.id, 'products' => brand.products.active.published.scoped(:order => 'arrived_at DESC', :limit => 50).map.assign_options(Shop::Product.simple_xml_options)} }

    respond_to do |format|
      format.xml { @data = {'brands' => @brands} }
    end
  end

  def legacy
    url = case
            when request.fullpath.match(/^(\/m)/)
              '/shop/products/men'
            when request.fullpath.match(/^(\/f)/)
              '/shop/products/women'
            when request.fullpath.match(/^(\/recent)/)
              '/shop/products/latest'
            when m = request.fullpath.match(/^\/brand\/(\d+)_?(\d+)?/)
              success, brand_id, page = m.to_a
              shop_brand_path(brand_id)
            when request.fullpath.match(/^(\/brand)/)
              shop_brands_path
            when m = request.fullpath.match(/^\/category\/(\d+)_(\d+)_(\d+)_?(\w)?/)
              success, level, category_id, page, target = m.to_a
              shop_products_path({"where[category#{level}_id]" => category_id}.merge(target ? {'where[target]' => {'m' => 'men', 'f' => 'women'}[target]} : {}))
            when m = request.fullpath.match(/^\/product\/(\d+)/)
              success, id = m.to_a
              shop_product_path(id)
            else
              '/home'
          end
    redirect_to url, :status => :moved_permanently
  end

  def data
    @product = Shop::Product.acquire(params[:id])
    @comments_count=@product.comments.count
  end

  private

  def simple_products
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 50).to_i
    engine = params[:engine] || (RAILS_ENV == 'production' ? 'solr' : 'database')
    if engine == 'solr'
      options = [["wt", "json"], ["indent", "on"], ["fl", "id"], ["start", 0], ["rows", 10000000], ["fq", "active:true"], ["fq", "published:true"]]
      options += [["q", "*:*"], ["fq", "mall_id:1"], ["sort", "published_at desc"]]
      logger.info url = "http://#{SOLR_CONFIG['host']}:#{SOLR_CONFIG['port']}/solr/select?#{options.map { |k, v| "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}" }.join('&')}"
      data = (ActiveSupport::JSON.decode(Timeout::timeout(10) { HTTParty.get(url) }) rescue nil) || {}
      @product_ids = data['response']['docs'].map { |doc| doc['id'].to_i }
      @product_ids_this_page = (@product_ids[(page-1)*per_page, per_page]+['NULL']).join(',')
      @products = Shop::Product.scoped(:conditions => ["#{Shop::Product.quoted_table_name}.id IN (#{@product_ids_this_page})"], :order => "FIELD(id, #{@product_ids_this_page})")
    else
      @products = Shop::Product.active.published.scoped(:conditions => "mall_id = 1", :limit => per_page, :offset => (page-1)*per_page)._order({"published_at" => 'DESC'})
    end
  end

  def update_readings_count
    begin
      key = "product_readings_count_#{params[:id]}"
      c = Rails.cache.read(key)
      c = c.is_a?(Hash) && c[:count].is_a?(Fixnum) && c[:updated_at].is_a?(Time) ? c.dup : {:count => 0, :updated_at => Time.now}
      c[:count] += 1
      if c[:count].to_i > 1000 && c[:updated_at] < 72.hours.ago
        @product ||= Shop::Product.find(params[:id])
        @product.readings_count = @product.readings_count.to_i + c[:count].to_i
        @product.save_without_timestamping!
        c = {:count => 0, :updated_at => Time.now}
      end
      Rails.cache.write(key, c)
      logger.info "#{key} #{c.inspect}"
    rescue => e
      logger.info "product_readings_count_error #{e.message}"
    end
  end

def authorized?
    super
    true
  end

end
