class Admin::Shop::ProductsController < Admin::Shop::ApplicationController

  def index
    @products = ::Shop::Product.active
    if params[:query_content]
      ids = (ids = params[:query_content].scan(/\d+/).join(',')) && ids.blank? ? 'null' : ids
      @products = @products._where("id IN (#{ids})").order(params[:order] ? params[:order].map { |k, v| "#{k} #{v.upcase == 'ASC' ? 'ASC' : 'DESC'}" } : "FIELD(id, #{ids})").page(params[:page]).per(params[:per_page] = 99999)
    end
    @products = @products._where(params[:where])._order(params[:order]).page(params[:page])
    if params[:status]=="out_store"
      @products=@products.published.where("items_unsold_count=0")
    elsif params[:status]=="in_store"
      @products=@products.published.where("items_unsold_count!=0")
    end
    # @products = [].paginate(:page => 1) unless @current_user.can?(:index, ::Shop::Product.new) || @products.total_entries <= 1

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @products }
      format.csv { response.headers['Content-Disposition'] = 'attachment; filename=products.csv'; render :text => generate_csv(generate_tabulation(::Shop::Product::FIELDS.find{ |f| f[:name] == params[:table] }[:value], @products)), :layout => false }
      format.tsv { response.headers['Content-Disposition'] = 'attachment; filename=products.tsv'; render :text => generate_tsv(generate_tabulation(::Shop::Product::FIELDS.find{ |f| f[:name] == params[:table] }[:value], @products)), :layout => false }
      format.table { render :text => generate_table(generate_tabulation(::Shop::Product::FIELDS.find{ |f| f[:name] == params[:table] }[:value], @products)), :layout => false }
    end
  end

  def check
    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
    end
  end

  def show
    @product = ::Shop::Product.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { @data = @product }
      format.js { render :text => @product.to_json }
    end
  end

  def new
    @product = ::Shop::Product.new

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @product }
    end
  end

  def create
    @product = ::Shop::Product.new

    if params_product[:images_attributes].present?
      image_attributes=JSON.parse(params_product[:images_attributes]).map { |item| item.merge({"active" => true, "user_id" => @current_user.id}) }
      params_product.delete(:images_attributes)
      @product.images_attributes=image_attributes
    end
    # params_product[:operation_images_attributes] = params_product[:operation_images_attributes] && params_product[:operation_images_attributes].sort_by { |key, attributes| key.to_i }.map { |key, attributes| attributes.slice(*(%w[id active]+::Shop::ProductOperationImage.manage_fields)) }
    # params_product[:videos_attributes] = params_product[:videos_attributes] && params_product[:videos_attributes].sort_by { |k, p| k.to_i }.map { |k, p| !p[:mp4].blank? || !p[:flv].blank? || !p[:swf].blank? || !p[:hd].blank? || !p[:description].blank? ? p.merge(:active => true, :editor_id => @current_user.id) : nil }.compact || []

    success = database_transaction do
      @product.attributes = params_product.merge(:user_id => @current_user.id)
      # @product.percent = (p = @product.price) > 0 && (d = @product.discount) >= 0 && p >= d ? d*100/p : nil
      @product.save!
      # @product.sync_sell_data!
    end

    respond_to do |format|
      if success
        flash[:notice] = 'Editor was successfully created.'
        format.html { redirect_to admin_shop_product_path(@product) }
        format.xml { render :xml => @product, :status => :created, :location => @product }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @product = ::Shop::Product.find(params[:id])
    # @root=::Shop::Category.find(1)
    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @product }
    end
  end

  def update
    @product = ::Shop::Product.find(params[:id])
    if params_product
      # params_product[:images_attributes]=params_product[:images_attributes] && JSON.parse(params_product[:images_attributes])
      # params_product[:images_attributes] = params_product[:images_attributes] && params_product[:images_attributes].sort_by { |k, p| k.to_i }.map { |k, p| p[:id] || !p[:large].blank? || !p[:medium].blank? || !p[:small].blank? || !p[:description].blank? ? p.merge(:active => true, :user_id => @current_user.id) : nil }.compact || []
      # params_product[:images_attributes] += params[:product_images_large_files].to_a.map { |file| { :large => file, :active => true, :user_id => @current_user.id } }
      # console.log(params_product[:images_attributes])
      # params_product[:operation_images_attributes] = params_product[:operation_images_attributes].sort_by { |key, attributes| key.to_i }.map { |key, attributes| attributes.slice(*(%w[id active]+::Shop::ProductOperationImage.manage_fields)) } if params_product && params_product[:operation_images_attributes]
      # params_product[:videos_attributes] = params_product[:videos_attributes] && params_product[:videos_attributes].sort_by { |k, p| k.to_i }.map { |k, p| p[:id] || !p[:mp4].blank? || !p[:flv].blank? || !p[:swf].blank? || !p[:hd].blank? || !p[:description].blank? ? p.merge(:active => true, :editor_id => @current_user.id) : nil }.compact || []
    end

    if params[:product][:images_attributes].present?
      image_attributes=JSON.parse(params[:product][:images_attributes]).map { |item| item.merge({"active" => true, "user_id" => @current_user.id}) }
      @product.images_attributes=image_attributes
    end

    success = database_transaction do
      # @product.discount_history = @product.discount_history.to_s + [@product.discount, params_product[:discount].to_i, @current_user.id, Time.now.to_s(:db)].to_csv if params_product[:discount] && params_product[:discount].to_i != @product.discount
      # params_product.delete_if{|k, v| k == 'price' || k == 'discount' || k == 'original_price' } if @product.items.unsold.count == 0
      # params_product.except(:active, :published, :lock_version, :updated_at).merge(:user_id => @current_user.id)
      @product.attributes = params_product
      # @product.percent = (p = @product.price) > 0 && (d = @product.discount) >= 0 && p >= d ? d*100/p : nil
      # @product.remark = @product.remark.to_s+' ' if !@product.changed? && (@product.images.map(&:changed?).inject(&:|) || @product.operation_images.any?(&:changed?) || @product.videos.map(&:changed?).inject(&:|) || @product.values.group_by(&:attribute_id).sort.map{|id,group| [id,group.map(&:content).sort.join(',')].join('=') }.join('&') != params['attributes'].map{|id,group|[id.to_i,group]}.sort.reject{|id,group| group.blank? }.map{|id,group| [id,group.to_a.map(&:split).flatten.sort.join(',')].join('=') }.join('&')) # ugly implement to tell whether images or videos or attributes changed
      @product.edited_at = Time.now if @product.changed?
      changed = @product.changed?
      @product.save!
      @product.sync_sell_data!

      # merge existing values with form parameters
      if params[:attributes]
        values = @product.values.active
        options = (params[:attributes]||[[0, '']]).map { |id, contents| (contents.is_a?(String) ? contents.split : contents).map { |content| [id.to_i, content] } }.inject(&:+).reject { |option| option.blank?||option.map(&:blank?).inject { |a, b| a||b } }
        values.reject { |value| options.find { |option| option == [value.attribute_id, value.content] } }.map { |v| v.update_attributes!(:active => false) }
        options.reject { |option| values.to_a.find { |value| option == [value.attribute_id, value.content] } }.map { |id, content| attribute = Shop::Attribute.find(id); Shop::Value.create!(:attribute_id => attribute.id, :attribute_name => attribute.name, :content => content, :product_id => @product.id, :editor_id => @current_user.id) }
      end

      @product.updatings.create!(:editor_id => @current_user.id, :data => @product.assign_options(::Shop::Product.new_xml_options).to_json) if changed
    end

    respond_to do |format|
      if success
        flash[:notice] = 'Product was successfully updated.'
        format.html { redirect_to admin_shop_product_path(@product) }
        format.js { head :ok }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.js { raise }
        format.xml { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  def delete
    @product = ::Shop::Product.find(params[:id])

    respond_to do |format|
      format.html { render template: 'admin/shared/delete', locals: {record: @product, unable_msg: '有所属单件而不能删除？'}, :layout => false }
      format.xml { render :xml => @product }
    end
  end


  def batch_delete
    @products = ::Shop::Product.where(id: params[:ids].split(","))
    respond_to do |format|
      format.html { render template: 'admin/shared/batch_delete', locals: {records: @products,del_url: admin_shop_products_path(:id=>@products.map(&:id).join(",")), unable_msg: '该产品无法删除？'}, :layout => false }
      format.xml { render :xml => @products }
    end
  end


  def destroy
    @products = ::Shop::Product.where(id: params[:id])

    # unless @product.deletable?
    #   not_authorized
    #   return
    # end

    success = database_transaction do
      @products.each do |proucts|
        product.destroy_softly
        product.sync_sell_data!
      end
    end

    respond_to do |format|
      if success
        format.html { redirect_to admin_shop_products_path, :status => :ok }
        format.xml { head :ok }
      else

      end
    end
  end

  def publish
    @products = ::Shop::Product.where(id: params[:id]||params[:ids] && params[:ids].split(","))

    # if @product.published?
    #   not_authorized
    #   return
    # end

    success = database_transaction do
      @products.each do |product|
        product.update_attributes!(:published => true)
        product.sync_sell_data!
        # product.updatings.create!(:editor_id => @current_user.id, :published => product.published?)
      end
    end

    respond_to do |format|
      format.html { redirect_to admin_shop_products_path }
      format.js { head :ok }
      format.xml { head :ok }
    end
  end

  def unpublish
    @products = ::Shop::Product.where(id: params[:id]||params[:ids] && params[:ids].split(","))

    # if !@product.published?
    #   not_authorized
    #   return
    # end

    success = database_transaction do
      @products.each do |product|
        product.update_attributes!(:published => false)
        product.sync_sell_data!
        # product.updatings.create!(:editor_id => @current_user.id, :published => product.published?)
      end
    end

    respond_to do |format|
      format.html { redirect_to admin_shop_products_path }
      format.js { head :ok }
      format.xml { head :ok }
    end
  end

  def preview
    @enable_lazyload = false
    @product = ::Shop::Product.find(params[:id])
    @comments = @product.comments.limit(10)

    render :layout => 'purple/application'
  end

  def clear
    @urls = params[:urls].map(&:split).flatten.map do |url|
      path = url = url.gsub(/^\w+:\/\/[^\/]+\//, '/')
      url = Digest::MD5.hexdigest(url) if url.match(/^\/shop\/products(\.\w+)?\?/)
      url += 'index' if url =~ /\/$/
      if !url.match(/\.\w+$/) && (format = (path.match(/\.(\w+)/)||[])[1]);
        url = "#{url}.#{format}";
      end
      success = Rails.cache.delete("views//mobile#{url}") & Rails.cache.delete("views/#{url}")
      [path, success]
    end
  end

  def sync
    @product = ::Shop::Product.find_by(id: params[:id]) || ::Shop::Product.new
    @product.id = params[:id]

    @success = database_transaction do
      @product.sync!(@current_user)
    end

    if @success
      respond_to do |format|
        format.html { redirect_to admin_shop_products_path }
        format.js { head :ok }
        format.xml { @data = {'product' => @product} }
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_shop_products_path }
        format.js { raise }
        format.xml { raise ActiveRecord::RecordInvalid.new(@product || Product.new) }
      end
    end
  end

  def updatings
    @updating = ::Shop::ProductsUpdating.find(params[:uid])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @updating }
    end
  end

  def price_edit
    # @query_options = CSV.parse(params[:csvs].map{|csv| csv.respond_to?(:read) ? csv.read : csv }.join("\n")).uniq.reject{|k, v| k.blank? || k.to_s.strip.match(/^\d+$/).blank? || v.blank? || v.to_s.strip.match(/^\d+$/).blank? }.compact.inject([]){|h,p| h << {'id'=>p[0], 'price'=>p[1]} and h }
    # @products = ::Shop::Product.active.where(params[:where]).order(params[:order]).scoped(:conditions =>"id IN (#{@query_options.blank? ? 'null' : @query_options.map{|p| p['id'] }.join(',')})")
    csv = CSV.parse(params[:csvs].map { |csv| csv.respond_to?(:read) ? csv.read.toutf8 : csv }.join("\n").strip).reject { |c| c[0].blank? }
    database_transaction do
      products = ::Shop::Product.active.find(csv.map(&:first).map(&:to_i).uniq)
      csv.each do |id, price, discount, original_price, minimum_price|
        id = id.to_i
        price = price.blank? ? nil : price.to_i
        discount = discount.to_i
        original_price = original_price.blank? ? nil : original_price.to_i
        minimum_price = minimum_price.blank? ? nil : minimum_price.to_i
        product = products.find { |product| product.id == id }
        next unless product && discount >= 0 && product.items.active.unsold.count > 0
        product.discount_history = product.discount_history.to_s + [product.discount, discount, @current_user.id, Time.now.to_s(:db)].to_csv if product.discount != discount
        product.price = price
        product.discount = discount
        product.original_price = original_price
        product.minimum_price = minimum_price
        product.percent = (p = product.price) > 0 && (d = product.discount) >= 0 && p >= d ? d*100/p : nil
        product.edited_at = Time.now
        product.user_id = @current_user.id
        product.save!
        product.sync_sell_data!
        product.updatings.create!(:editor_id => @current_user.id, :data => product.assign_options(::Shop::Product.new_xml_options).to_json)
        Shop::Product.clear_product_caches(product['id'])
      end
    end
    render :text => '', :layout => true
  end

  def batch_edit
    # ids = CSV.parse(params[:csvs].map { |csv| csv.respond_to?(:read) ? csv.read : csv }.join("\n").gsub(/[\r\n]+/, "\n").strip).map { |line| line[0].to_i }.uniq.compact
    @products = ::Shop::Product.active._where(params[:where])._order(params[:order]).where(id: params[:ids].split(","))

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @products }
    end
  end

  def batch_update
    @products = ::Shop::Product.active.where(params[:where]).order(params[:order]).where("id IN (#{params[:products].map { |p| p[:id] }.map(&:to_i).join(',')})")

    success = database_transaction do
      @products.each do |product|
        product.attributes = params_product.slice(*%w[label prefix mall_id category1_id category2_id category3_id brand_id multibuy_id color target recommend arrived_at published_at])
        if product.changed?
          product.edited_at = Time.now
          product.user_id = @current_user.id
          product.save!
          product.updatings.create!(:editor_id => @current_user.id, :data => product.assign_options(::Shop::Product.new_xml_options).to_json)
        end
      end
    end
    raise unless success

    respond_to do |format|
      format.html { redirect_to admin_shop_products_path }
      format.xml { head :ok }
    end
  end

  def error_caches
    @products = ::Shop::Product.active.scoped(:select => "id, name, updated_at", :order => "id ASC")
    caches = $cache.get(@products.map { |product|
                          ['', '.xml', '.json', '/response_summary.xml', '/response_summary.json'].map { |fmt|
                            ["views//shop/products/#{product.id}#{fmt}", "views//mobile/products/#{product.id}#{fmt}"]
                          } }.flatten)
    @abnormal_caches = @products.map { |product|
      product_cache = {:id => product.id, :name => product.name}
      {
        "html" => "views//shop/products/#{product.id}",
        "xml" => "views//shop/products/#{product.id}.xml",
        "json" => "views//shop/products/#{product.id}.json",
        "summary_xml" => "views//shop/products/#{product.id}/response_summary.xml",
        "summary_json" => "views//shop/products/#{product.id}/response_summary.json",
      }.each do |k, v|
        if caches.has_key? v
          updated_at = caches[v].match(/<updated_at>([^<]*)<\/updated_at>|updated_at":"([^"]*)"/)[1, 2].compact[0].to_s rescue nil
          if updated_at && product.updated_at && updated_at != product.updated_at.xmlschema
            product_cache["#{k}_database"] = product.updated_at
            product_cache["#{k}_cache"] = Time.parse updated_at
          end
        end
      end
      product_cache.keys == [:name, :id] ? nil : product_cache
    }.compact

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @abnormal_caches }
    end
  end

  protected

  def params_product
    params[:product].permit(["pic", "list_pic", "body", "spec_pic_pic", "color_pic", "category1_id", "category2_id", "category3_id",
                             "price", "discount", "color_pic_pic", "match_pic", "major_pic", "label", "prefix", "name", "keywords",
                             "remark", "description", "measure_suggestion", "measure_description", "measure_style", "color_name",
                             "match_product_ids", "order", "styles", "brand_link", "brand_description", "cart_pic", "accelerator",
                             "material", "category_id", "brand_id", "relate_product_ids", "scarcity", "point", "zoom", "color", "target",
                             "thickness", "elasticity", "pliability", "recommend", "extra_description", "arrived_at", "published_at", "identifier"])
    # params_product.permit!
  end
end
