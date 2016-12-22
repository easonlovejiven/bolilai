class Admin::Shop::BrandsController < Admin::Shop::ApplicationController
  def index
    @brands = ::Shop::Brand.active._where(params[:where])._order(params[:order]).page(params[:page]).per(params[:per_page])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { @data = @brands }
    end
  end

  def show
    @brand = ::Shop::Brand.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @brand }
    end
  end

  def new
    @brand = ::Shop::Brand.new

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @brand }
    end
  end

  def create
    success = database_transaction do
      brand_params[:images_attributes] = brand_params[:images_attributes] && brand_params[:images_attributes].sort_by { |key, attributes| key.to_i }.map { |key, attributes| attributes.slice(*(%w[id active]+Shop::BrandImage.manage_fields)) }
      @brand = ::Shop::Brand.new(brand_params.merge(:editor_id => @current_user.id))
      @brand.save!
      # ErpRecord.connection.execute("INSERT INTO ruby_message(type, update_type, update_id, add_time, update_time) VALUES('BRAND', 'INSERT', #{@brand.id}, #{Time.now.to_i}, #{Time.now.to_i});") rescue nil
    end

    respond_to do |format|
      if success
        flash[:notice] = 'Brand was successfully created.'
        format.html { redirect_to admin_shop_brand_path(@brand) }
        format.xml { render :xml => @brand, :status => :created, :location => @brand }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @brand.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @brand = ::Shop::Brand.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @brand }
    end
  end

  def update
    success = database_transaction do
      @brand = ::Shop::Brand.find(params[:id])
      brand_params[:images_attributes] = brand_params[:images_attributes] && brand_params[:images_attributes].sort_by { |key, attributes| key.to_i }.map { |key, attributes| attributes.slice(*(%w[id active]+Shop::BrandImage.manage_fields)) }
      @brand.update_attributes!(brand_params)
      ErpRecord.connection.execute("INSERT INTO ruby_message(type, update_type, update_id, add_time, update_time) VALUES('BRAND', 'UPDATE', #{@brand.id}, #{Time.now.to_i}, #{Time.now.to_i});") rescue nil
    end

    respond_to do |format|
      if success
        flash[:notice] = 'Brand was successfully updated.'
        format.html { redirect_to admin_shop_brand_path(@brand) }
        format.js { head :ok }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.js { raise }
        format.xml { render :xml => @brand.errors, :status => :unprocessable_entity }
      end
    end
  end

  def delete
    @brand = ::Shop::Brand.find(params[:id])

    respond_to do |format|
      format.html { render template: 'admin/shared/delete', locals: {record: @brand, unable_msg: '有被产品选择而无法删除？'}, :layout => false }
      format.xml { render :xml => @brand }
    end
  end

  def destroy
    @brand = ::Shop::Brand.find(params[:id])

    unless @brand.deletable?
      not_authorized
      return
    end

    success = database_transaction do
      @brand.destroy_softly
      ErpRecord.connection.execute("INSERT INTO ruby_message(type, update_type, update_id, add_time, update_time) VALUES('BRAND', 'DEL', #{@brand.id}, #{Time.now.to_i}, #{Time.now.to_i});") rescue nil
    end

    respond_to do |format|
      format.html { redirect_to admin_shop_brands_path }
      format.xml { head :ok }
    end
  end

  def publish
    @brand = ::Shop::Brand.acquire(params[:id])
    @brand.update_attribute(:published, true)
    Rails.cache.delete("views/#{HOSTS['dynamic']}/shop/brands/#{@brand.id}.xml")
    Rails.cache.delete("views/#{HOSTS['dynamic']}/shop/brands.xml?page=1&per_page=9999.xml")

    respond_to do |format|
      format.html { redirect_to admin_shop_brands_path }
      format.js { head :ok }
      format.xml { head :ok }
    end
  end

  def unpublish
    @brand = ::Shop::Brand.acquire(params[:id])
    @brand.update_attribute(:published, false)

    respond_to do |format|
      format.html { redirect_to admin_shop_brands_path }
      format.js { head :ok }
      format.xml { head :ok }
    end
  end

  protected
  def brand_params
    params[:brand].permit(["name", "pic", "chinese", "abbreviation", "initial", "genre", "link", "shop_link", "title", "description", "summary", "year", "founded_on", "keywords", "special_product_ids", "order", "recommend", "introduced"])
  end
end
