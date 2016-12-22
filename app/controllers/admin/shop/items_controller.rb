class Admin::Shop::ItemsController < Admin::Shop::ApplicationController

  def index
    @items = model.active.where(params[:query] && ['id = :q OR identifer = :q OR barcode = :q', {q: params[:query]}])._where(params[:where])._order(params[:order]).page(params[:page]).per(params[:per_page])
    # @items = [].paginate(:page => 1) unless @current_user.can?(:index, Shop::Item.new) || @items.total_entries <= 1

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { @data = @items.assign_options(include: {product: {include: {multibuy: {except: []}}}}) }
      format.csv { response.headers['Content-Disposition'] = 'attachment; filename=items.csv'; render :layout => false }
      format.js { render :json => @items }
    end
  end

  def show
    @item = Shop::Item.acquire(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { @data = @item.assign_options(include: [:product]) }
      format.js { render :json => {:id => @item.id, :name => @item.product&&@item.product.name}.to_json }
    end
  end

  def new
    @item = Shop::Item.new
    @item.product=Shop::Product.find(params[:product_id]) if !params[:product_id].blank?
    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @item }
    end
  end

  def create
    @success = database_transaction do
      i = params[:count].to_i
      raise if i > 100 || i <= 0
      @items = (1..i).map { Shop::Item.create!(item_params.merge(:user_id => @current_user.id)) }
      @items[0].product.sync_sell_data!
    end

    respond_to do |format|
      if @success
        flash[:notice] = 'Item was successfully created.'
        format.html { redirect_to admin_shop_items_path }
        format.xml
      else
        format.html { redirect_to request.referer || admin_shop_items_path }
        format.xml
      end
    end
  end

  def edit
    @item = Shop::Item.acquire(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @item }
    end
  end

  def update
    @item = Shop::Item.acquire(params[:id])

    success = database_transaction do
      @item.update_attributes!(item_params.slice(:measure, :factory_measure, :remark,:identifer).merge(:user_id => @current_user.id))
      @item.product.sync_sell_data!
    end

    respond_to do |format|
      if success
        flash[:notice] = 'Product was successfully updated.'
        format.html { redirect_to admin_shop_item_path(@item), :status => :ok }
        format.js { head :ok }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.js { raise }
        format.xml { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def delete
    @item = Shop::Item.acquire(params[:id])

    respond_to do |format|
      format.html { render template: 'admin/shared/delete', locals: {record: @item, unable_msg: '此单件无法删除？'}, :layout => false }
      format.xml { render :xml => @item }
    end
  end

  def destroy
    @item = Shop::Item.acquire(params[:id])

    unless @item.deletable?
      not_authorized
      return
    end

    success = database_transaction do
      @item.update_attributes!(:active => false)
      @item.product.sync_sell_data!
    end

    respond_to do |format|
      format.html { redirect_to admin_shop_items_path, :status => :ok }
      format.xml { head :ok }
    end
  end

  def publish
    @item = Shop::Item.acquire(params[:id])

    if @item.trade_id || @item.published?
      not_authorized
      return
    end

    success = database_transaction do
      @item.update_attributes!(:published => true)
      @item.product.sync_sell_data!
      @item.updatings.create!(:editor_id => @current_user.id, :published => @item.published?)
    end

    respond_to do |format|
      format.html { redirect_to admin_shop_items_path, :status => :ok }
      format.js { head :ok }
      format.xml { head :ok }
    end
  end

  def unpublish
    @item = Shop::Item.acquire(params[:id])

    if @item.trade_id || !@item.published?
      not_authorized
      return
    end

    success = database_transaction do
      @item.update_attributes!(:published => false)
      @item.product.sync_sell_data!
      @item.updatings.create!(:editor_id => @current_user.id, :published => @item.published?)
    end

    respond_to do |format|
      format.html { redirect_to admin_shop_items_path, :status => :ok }
      format.js { head :ok }
      format.xml { head :ok }
    end
  end

  def import
    @query_options = CSV.parse(params[:csvs].map { |csv| csv.respond_to?(:read) ? csv.read.toutf8 : csv }.join("\n").gsub(/[\r\n]+/, "\n").strip).uniq.reject { |m| m[0].blank? || m[0].to_s.strip.match(/^\d+$/).blank? || m[1].blank? || m[2].blank? }.compact.inject([]) { |h, p| h << {'id' => p[0], 'measure' => p[1], 'factory_measure' => p[2]} and h }

    @items = Shop::Item.active._where(params[:where])._order(params[:order]).where("id IN (#{@query_options.blank? ? 'null' : @query_options.map { |p| p['id'] }.join(',')})")

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @items }
    end
  end

  def print
    @item = Shop::Item.acquire(params[:id])

    respond_to do |format|
      format.html { render :layout => false }
      format.xml { render :text => @item }
    end
  end

  protected

  def item_params
    params[:item].permit(["remark", "measure", "factory_measure", "product_id", "published","identifer"])
  end
end
