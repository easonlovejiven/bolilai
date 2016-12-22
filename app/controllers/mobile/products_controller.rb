class Mobile::ProductsController < Mobile::ApplicationController
  before_filter :update_readings_count, :only => :show
  caches_action :index, :expires_in => 3600,
                :cache_path => Proc.new { |ctr| Digest::MD5.hexdigest(ctr.generate_cache_url) }, :if => Proc.new { |ctr| ctr.request.params['ids'].blank? }
  caches_action :show, :expires_in => 1.month.to_i, :cache_path => Proc.new { |ctr| ctr.generate_cache_url }

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
      current_category_id=params[:where][:category2_id] || params[:where][:category1_id]
      @category=Shop::Category.find(current_category_id) if current_category_id
      case params[:name]
        when 'latest';
          params[:order][:arrived_at] = 'desc'
        when /men|women/;
          params[:where][:target] = params[:name]
      end
      @keyword=params[:keyword].try(:strip)
      !params[:keyword].blank? && (synonym = Shop::Synonym.active.published.find_by_name(params[:keyword].to_s.strip)) && (options = %w[brand_id category1_id category2_id target color].map { |k| (v = synonym.send(k)).blank? ? nil : {k => v} }.compact.inject(&:merge)) && options.map { |k, v| params[:where][k].blank? || params[:where][k] == v.to_s }.inject(&:&) && options.map { |k, v| params[:where][k] = v } && (params[:keyword] = nil)
      page = (params[:page] || 1).to_i
      per_page = (params[:per_page] || 40).to_i
      params[:where][:target] = {'men' => '男', 'women' => '女', 'nogender' => '无性别', 'children' => '儿童', }[params[:where][:target]] || params[:where][:target] if params[:where][:target]
      params[:where][:target].map! { |t| {'men' => '男', 'women' => '女', 'nogender' => '无性别', 'children' => '儿童', }[t] || t } if params[:where][:target].is_a?(Array)
      params[:where][:color] = Shop::Product::COLORS.map { |k, v| {v => k} }.inject(&:merge)[params[:where][:color]] || params[:where][:color] if params[:where][:color]
      params[:where][:color].map! { |c| Shop::Product::COLORS.map { |k, v| {v => k} }.inject(&:merge)[c] || c } if params[:where][:color].is_a?(Array)
      params[:where][:unsold_count] = {:gteq => 0} if (params[:format] || 'html') == 'html' && !params[:where][:unsold_count]
      engine = params[:engine] || (Rails.env == 'production' ? 'solr' : 'database')
    end
    if ids
      @products = Shop::Product.active.published.where("id IN (#{ids.join(',')})").order("FIELD(id,#{(ids+['NULL']).join(',')})")
    elsif engine == 'solr'
      # options = [["wt", "json"], ["indent", "on"], ["fl", "id"], ["start", (page-1)*per_page], ["rows", per_page], ["fq", "active:true"], ["fq", "published:true"], ["forceElevation", true]]
      options = [["wt", "json"], ["indent", "on"], ["fl", "id"], ["start", (page-1)*per_page], ["rows", per_page], ["forceElevation", true]]
      # options << ["fq", "mall_id:1"] unless params[:where][:mall_id]
      options << ["fq", (params[:where][:target].to_sz + [(params[:where][:target].to_sz & %w[男 女]).empty? ? nil : '中性']).compact.uniq.map { |t| "target:#{t}" }.join(' OR ')] if params[:where][:target]
      options << ["q", params[:keyword].blank? ? "*:*" : params[:keyword].to_s.strip.gsub(/[\+\-\&\|\!\(\)\{\}\[\]\^\"\~\*\?\:\\]/) { |c| "\\"+c }]
      options += (params[:values]||{}).map { |key, values| ["fq", [values].flatten.map { |value| %[values:"#{key}:#{value}"] }.join(' OR ')] }
      options += params[:where].slice(:measure, :id, :mall_id, :category1_id, :category2_id, :category3_id, :brand_id, :multibuy_id, :color, :recommend, :unsold_count, :arrived_at, :updated_at).merge(params[:where][:price] ? {:discount => params[:where][:price]} : {}).map { |f, value| value.is_a?(Hash) ? value.map { |op, v| v = v.to_s.strip.gsub(/[\+\-\&\|\!\(\)\{\}\[\]\^\"\~\*\?\:\\]/) { |c| "\\"+c }; ['fq', {'eq' => "#{f}:#{v}", 'noteq' => "-#{f}:#{v}", 'gteq' => "#{f}:[#{v} TO *]", 'lteq' => "#{f}:[* TO #{v}]", 'gt' => "-#{f}:[* TO #{v}]", 'lt' => "-#{f}:[#{v} TO *]", }[{'=' => 'eq', '<>' => 'noteq', '!=' => 'noteq', '>=' => 'gteq', '<=' => 'lteq', '>' => 'gt', '<' => 'lt'}[op]||op]] } : [['fq', value.to_sz.map { |v| "#{f}:#{v.to_s.strip.gsub(/[\+\-\&\|\!\(\)\{\}\[\]\^\"\~\*\?\:\\]/) { |c| "\\"+c }}" }.join(' OR ')]] }.inject([], &:+)
      options << ["sort", (o = params[:order].slice(:percent, :scarcity, :readings_count, :point, :arrived_at, :updated_at).merge(params[:order][:price] ? {:discount => params[:order][:price]} : {}).merge(params[:order][:created_at] ? {:arrived_at => params[:order][:created_at]} : {}).map { |k, v| "#{k} #{v.to_s.strip.gsub(/[\+\-\&\|\!\(\)\{\}\[\]\^\"\~\*\?\:\\]/) { |c| "\\"+c }}" }.join(',')) && !o.blank? ? o : "published_at desc"]
      options += %w[ category1_id category2_id category3_id color measure].keep_if { |field| params[:where][field].blank? }.map { |field| ["facet.field", field] } + [["facet", "true"], ["facet.sort", "count"], ["facet.mincount", 1], ["facet.limit", 100], ["facet.field", "searchable_values"], ["f.searchable_values.facet.limit", 10000]] + (params[:where][:price] ? [] : [["facet.range", "discount"], ["f.discount.facet.range.start", 0], ["f.discount.facet.range.end", 1000000], ["f.discount.facet.range.gap", 2000]]) # if page == 1
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
        @products_facet[:values]=@products_facet[:values].reject { |item| item[:options].blank? || item[:options].size<=1 }
        @products_facet.merge!(:price => (p = data["facet_counts"]["facet_ranges"] && data["facet_counts"]["facet_ranges"]["discount"]) && p["counts"].each_slice(2).map { |value, count| {:value => [value.to_i, value.to_i+p["gap"].to_i-1], :count => count} } || [])
        @products_facet = @products_facet.reject { |k, v| v.blank? } || {}
        # @filters = @products_facet.slice(*%w[category1_id category2_id category3_id  color measure].map(&:to_sym)).map { |field, values| {field => (values||[]).map { |v| v[:value] }} }.inject({}, &:merge).merge(:values => (@products_facet[:values]||[]).map { |value| {value[:name] => value[:options].map { |option| option[:value] }} }.inject({}, &:merge))
        # %w[category1_id category2_id category3_id color measure].each { |field| @filters[field.to_sym] ||= [] }
        # @filters.merge!(:maximum_price => (@products_facet[:price]||[]).map { |p| p[:value] }.flatten.max || 0, :minimum_price => (@products_facet[:price]||[]).map { |p| p[:value] }.flatten.min || 0)
        # @filters[:measures] = @filters.delete(:measure) unless @filters[:measure].blank?
      end
    elsif engine == 'database'
      @products = Shop::Product.active.published
      # @products = @products.where(mall_id: 1) unless params[:where][:mall_id]
      @products = @products.where((params[:where][:target].to_sz + [(params[:where][:target].to_sz & %w[男 女]).empty? ? nil : '中性']).compact.uniq.map { |t| "target = #{Shop::Product.sanitize(t)}" }.join(' OR ')) if params[:where][:target]
      @products = @products.where(params[:where][:measure].to_sz.map { |m| %[measures_unsold_count LIKE #{Shop::Product.sanitize(%[%"#{m}"%])} AND measures_unsold_count NOT LIKE #{Shop::Product.sanitize(%[%"#{m}":0%])}] }.join(' OR ')) if params[:where][:measure]
      @products = @products.where((keyword = params[:keyword].to_s.strip.gsub(/\s+/, "%")) && !keyword.blank? && ["name LIKE ? OR prefix LIKE ? OR label LIKE ?", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%"])
      @products = @products.joins(params[:values].each_with_index.map { |v, i| %[JOIN shop_values shop_values_#{i} ON shop_values_#{i}.product_id = auction_products.id AND shop_values_#{i}.active = TRUE AND (#{v[1].to_sz.map { |c| %[shop_values_#{i}.attribute_name = #{Shop::Value.sanitize(v[0])} AND shop_values_#{i}.content = #{Shop::Value.sanitize(c)}] }.join(' OR ')})] }.join(' ')) if params[:values]
      @products = @products._where((params[:where] || {}).slice(:id, :category1_id, :category2_id, :category3_id, :brand_id, :multibuy_id, :color, :recommend, :unsold_count, :arrived_at, :updated_at).merge(params[:where][:price] ? {:discount => params[:where][:price]} : {}))
      @products_count = @products.count
      if 1 # >= params[:page].to_i
        @products_facet = %w[category1_id category2_id category3_id  color ].map(&:to_sym).map { |field| {field => @products.select("#{Shop::Product.quoted_table_name}.#{field} AS field, COUNT(*) AS cnt").group("#{Shop::Product.quoted_table_name}.#{field}").order("cnt DESC").limit(100).map { |p| {:value => p.field, :count => p.cnt.to_i} }.sort_by { |p| p[:count] }.reverse} }.inject(&:merge)
        category = (id = params[:where][:category1_id]) && (category = Shop::Category.find_by_id(id)) || (id = params[:where][:category2_id]) && (category = Shop::Category.find_by_id(id)) || Shop::Category.find_by_id(1) || Shop::Category.new
        @products_facet.merge!(:price => (ranges = category.ranges.to_s.split(',').map(&:to_i)) && (0..ranges.size-1).map { |i| a=i==0 ? 0 : ranges[i-1]; b=ranges[i]; (count = @products.where("discount >= ? AND discount <= ?", a, b).count) && count > 0 ? {:value => [a, b], :count => count} : nil }.compact)
        @products_facet.merge!(:measure => @products.select(:measures_unsold_count).where("measures_unsold_count IS NOT NULL").map { |p| (ActiveSupport::JSON.decode(p.measures_unsold_count) rescue {}).reject { |k, v| v == 0 }.keys.reject { |m| !category.measures.split(',').include?(m) } }.flatten.compact.reject(&:blank?).group_by(&:to_s).map { |value, group| {:value => value, :count => group.size} }.sort_by { |p| p[:count] }.reverse[0..99]) unless category.measures.blank?
        @products_facet.merge!(:values => category.inheritance_attributes.keep_if(&:searchable?).map { |attribute| {:name => attribute.name, :options => @products.select("#{Shop::Value.quoted_table_name}.content, COUNT(*) AS cnt").joins("JOIN #{Shop::Value.quoted_table_name} ON #{Shop::Value.quoted_table_name}.product_id = #{Shop::Product.quoted_table_name}.id").where("#{Shop::Value.quoted_table_name}.attribute_id = ? AND #{Shop::Value.quoted_table_name}.active = ?", attribute.id, true).group("#{Shop::Value.quoted_table_name}.content").order("cnt DESC").limit(100).map { |p| {:value => p.content, :count => p.cnt.to_i} }.sort_by { |p| p[:count] }.reverse}.delete_if { |k, v| v.blank? } })
        @products_facet = @products_facet.reject { |k, v| v.blank? } || {}
        @products_facet.slice(*%w[category1_id category2_id category3_id  color measure].map(&:to_sym)).map { |field, values| {field => (values||[]).map { |v| v[:value] }} }.inject({}, &:merge).merge(:values => (@products_facet[:values]||[]).map { |value| {name: value[:name], options: (value[:options]||[]).map { |option| {name: option[:value], count: option[:count]} }} }.inject({}, &:merge))
        # %w[category1_id category2_id category3_id  color measure].each { |field| @filters[field.to_sym] ||= [] }
        # @filters.merge!(:maximum_price => (@products_facet[:price]||[]).map { |p| p[:value] }.flatten.max || 0, :minimum_price => (@products_facet[:price]||[]).map { |p| p[:value] }.flatten.min || 0)
        # @filters[:measures] = @filters.delete(:measure) unless @filters[:measure].blank?
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
          when params[:_format] == :json && params[:response] == 'summary' && (@ids = ids)
            render :action => 'index_summary.json', :layout => false, :content_type => Mime::JSON.to_s
          when params[:_format] == :xml && params[:response] == 'simple'
            render :action => 'index_simple.xml', :layout => false, :content_type => Mime::XML.to_s
          when params[:_format] == :json && params[:response] == 'simple'
            render :action => 'index_simple.json', :layout => false, :content_type => Mime::JSON.to_s
          when %w[simple summary slim].include?(params[:response]) || params[:response] == 'complete' && ids && ids.size == 1
            @data = {products: @products.includes(:brand).assign_options(only: %w[id discount major_pic], include: {brand: {only: %[name]}})} if params[:response] == 'slim'
            @data ||= {'products' => @products.map.assign_options(Shop::Product.xml_options_for(params[:response])), 'products_count' => @products_count, 'products_facet' => @products_facet.to_json, 'sticky_xml' => @sticky_xml, 'sticky' => @sticky}
        end
      }
    end
  end


  def show
    @product = Shop::Product.acquire(params[:id])
    if !@product.published
      not_authorized
      return
    end

    respond_to do |format|
      format.html { @enable_lazyload = false }
      format.spider
      format.xml { @data = {'product' => @product.assign_options(Shop::Product.new_xml_options)} }
    end
  end

  def update_readings_count
    begin
      key = "mobile_product_readings_count_#{params[:id]}"
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
      logger.info "mobile_product_readings_count_error #{e.message}"
    end
  end

  def authorized?
    @enable_lazyload = true
    return true if %w[index show].include?(params[:action])
    @current_user = Shop::User.acquire(@current_user.id) if @current_user
    !!@current_user
  end

end
