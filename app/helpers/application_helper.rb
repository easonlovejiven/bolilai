module ApplicationHelper
  def stylesheet_inline_tag(*sources)
    content_tag :style, raw(sources.to_a.map { |source| Rails.application.assets.find_asset(source).to_s }.join), type: "text/css", scoped: ""
  end

  def javascript_inline_tag(*sources)
    content_tag :script, raw(sources.to_a.map { |source| Rails.application.assets.find_asset(source).to_s }.join), type: "text/javascript", scoped: ""
  end

  def logo_pic
    logo_str = 'logo2.png'
    logo_str
  end

  #oem代理商logo替换
  def logo_pic_by_domain
    logo_str = 'logo2.png'
    logo_str
  end

  def display_error_messages!(resource='')
    return '' if resource.blank? || resource.errors.empty?
    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
     <div class="alert alert-warning">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true"></button>
      <ul>#{messages}</ul>
    </div>
    HTML
    html.html_safe
  end

  def can? *argv
    @current_user && @current_user.respond_to?(:can?) && @current_user.can?(*argv)
  end

  def conditions_path(options = {})
    param = params.slice(*%w[where order keyword]).deep_merge(options).to_param.split('&').reject { |p| !p.match(/^.+=.+$/) }.sort.join('&')
    '/shop/products' + (param.blank? ? '' : '?') + param
  end

  def legacy_url(url, skip = false)
    url = url.to_s
    return url if skip || !url.match(/#subapp/)
    case
      when m = url.match(/productId=(\d+)/)
        shop_product_path(m[1])
      when m = url.match(/target=([\u4e00-\u9fa5\w%]+)&category1_id=(\d+)&brand=(\d+)/)
        shop_products_path(:where => {:target => {'男' => 'men', '女' => 'women'}[URI.decode(m[1])], :category1_id => m[2], :brand_id => m[3]})
      when m = url.match(/target=([\u4e00-\u9fa5\w%]+)&category2_id=(\d+)&brand=(\d+)/)
        shop_products_path(:where => {:target => {'男' => 'men', '女' => 'women'}[URI.decode(m[1])], :category2_id => m[2], :brand_id => m[3]})
      when m = url.match(/target=([\u4e00-\u9fa5\w%]+)&category1_id=(\d+)&fbrand=(\d+)/)
        shop_products_path(:where => {:target => {'男' => 'men', '女' => 'women'}[URI.decode(m[1])], :category1_id => m[2], :brand_id => m[3]})
      when m = url.match(/target=([\u4e00-\u9fa5\w%]+)&category2_id=(\d+)&fbrand=(\d+)/)
        shop_products_path(:where => {:target => {'男' => 'men', '女' => 'women'}[URI.decode(m[1])], :category2_id => m[2], :brand_id => m[3]})
      when m = url.match(/target=([\u4e00-\u9fa5\w%]+)&category1_id=(\d+)/)
        shop_products_path(:where => {:target => {'男' => 'men', '女' => 'women'}[URI.decode(m[1])], :category1_id => m[2]})
      when m = url.match(/target=([\u4e00-\u9fa5\w%]+)&category2_id=(\d+)/)
        shop_products_path(:where => {:target => {'男' => 'men', '女' => 'women'}[URI.decode(m[1])], :category2_id => m[2]})
      when m = url.match(/category1_id=(\d+)&brand=(\d+)/)
        shop_products_path(:where => {:category1_id => m[1], :brand_id => m[2]})
      when m = url.match(/category2_id=(\d+)&brand=(\d+)/)
        shop_products_path(:where => {:category2_id => m[1], :brand_id => m[2]})
      when m = url.match(/category1_id=(\d+)&fbrand=(\d+)/)
        shop_products_path(:where => {:category1_id => m[1], :brand_id => m[2]})
      when m = url.match(/category2_id=(\d+)&fbrand=(\d+)/)
        shop_products_path(:where => {:category2_id => m[1], :brand_id => m[2]})
      # when m = url.match(/category1_id=(\d+)&fcolor=([\u4e00-\u9fa5]+)/)
      # 	shop_products_path(:where => { :category1_id => m[1], :color => m[2] })
      # when m = url.match(/category2_id=(\d+)&fcolor=([\u4e00-\u9fa5]+)/)
      # 	shop_products_path(:where => { :category2_id => m[1], :color => m[2] })
      when m = url.match(/category1_id=(\d+)/)
        shop_products_path(:where => {:category1_id => m[1]})
      when m = url.match(/category2_id=(\d+)/)
        shop_products_path(:where => {:category2_id => m[1]})
      when m = url.match(/extid=(\d+)/)
        shop_product_path(m[1])
      when m = url.match(/brand=(\d+)/)
        shop_products_path(:where => {:brand_id => m[1]})
      when m = url.match(/keyword=([^&]+)/)
        shop_products_path(:keyword => URI.decode(m[1]))
      when m = url.match(/channel=brand/)
        shop_brands_path
      when m = url.match(/channel=treasure/)
        shop_products_path(:where => {:category1_id => 203})
      when m = url.match(/channel=store/)
        shop_page_path('store')
      when m = url.match(/channel=sales/)
        shop_products_path(:where => {:mall_id => 20})
      when m = url.match(/channel=treasure/)
        shop_products_path(:where => {:category1_id => 203})
      else
        shop_root_path
    end
  end

  def time_format(date)
    date.strftime("%Y-%m-%d %H:%M")
  end

  def get_day_array(month)
    days = case month
             when 2
               (1..29)
             when 2, 4, 6, 9, 11
               (1..30)
             else
               (1..31)
           end
    days.to_a
  end

  def two_columns_array(attrs, num)
    result=[]
    items=[]
    attrs.each_with_index do |attr, index|
      items.push(attr)
      if index==0 || index%num==0
        result.unshift(items)
        items=[]
      end
    end
    result
  end

  def cache_items(objects, key_template, root, type = 'xml', skip_options = true)
    options = {skip_instruct: true, dasherize: false, skip_types: true, root: root }
    keys = objects.collect { |obj| (key_template % [obj[:id], obj[:updated_at].to_i]) + ".#{type}" }
    content = Rails.cache.fetch_multi(*keys) do |key|
      obj = objects.find{ |o| o[:id] == key.match(/\/(\d+)(\/|\.|_)/)[1].to_i }
      case type
        when 'xml'
          obj.to_xml(options)
        when 'json'
          skip_options ? obj.to_json : obj.to_json(options)
      end
    end
  end

end
