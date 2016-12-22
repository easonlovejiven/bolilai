class Admin::Shop::CategoriesController < Admin::Shop::ApplicationController

  def index
    @categories = ::Shop::Category.active._where(params[:where])._order(params[:order]).page(params[:page]).per(params[:per_page])
    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @categories }
    end
  end

  def show
    @category = ::Shop::Category.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @category }
    end
  end

  def new
    @category = ::Shop::Category.new

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @category }
    end
  end

  def create
    success = database_transaction do
      @category = ::Shop::Category.new(category_params.merge(:user_id => @current_user.id))
      @category.save!
      # ErpRecord.connection.execute("INSERT INTO ruby_message(type, update_type, update_id, add_time, update_time) VALUES('CAT', 'INSERT', #{@category.id}, #{Time.now.to_i}, #{Time.now.to_i});") rescue nil
    end

    respond_to do |format|
      if success
        flash[:notice] = 'category was successfully created.'
        format.html { redirect_to admin_shop_category_path(@category) }
        format.xml { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @category = ::Shop::Category.find(params[:id])
    @kclass=::Shop::Category
    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @category }
    end
  end

  def update
    success = database_transaction do
      @category = ::Shop::Category.find(params[:id])
      @category.update_attributes!(category_params)
      ErpRecord.connection.execute("INSERT INTO ruby_message(type, update_type, update_id, add_time, update_time) VALUES('CAT', 'UPDATE', #{@category.id}, #{Time.now.to_i}, #{Time.now.to_i});") rescue nil
    end

    respond_to do |format|
      if success
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to admin_shop_category_path(@category) }
        format.js { head :ok }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.js { raise }
        format.xml { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def delete
    @category = ::Shop::Category.find(params[:id])

    respond_to do |format|
      format.html { render template: 'admin/shared/delete', locals: {record: @category, unable_msg: @category.root? ? '根节点无法删除' : '有子类或所属产品而无法删除'}, :layout => false }
      format.xml { render :xml => @category }
    end
  end

  def destroy
    @category = ::Shop::Category.find(params[:id])

    unless @category.deletable?
      not_authorized
      return
    end

    success = database_transaction do
      @category.destroy_softly
    end

    respond_to do |format|
      format.html { redirect_to admin_shop_categories_path, status: :ok }
      format.xml { head :ok }
    end
  end

  def publish
    @category = ::Shop::Category.acquire(params[:id])
    @category.update_attribute(:published, true)

    respond_to do |format|
      format.html { redirect_to admin_shop_categories_path }
      format.js { head :ok }
      format.xml { head :ok }
    end
  end

  def unpublish
    @category = ::Shop::Category.acquire(params[:id])
    @category.update_attribute(:published, false)

    respond_to do |format|
      format.html { redirect_to admin_shop_categories_path }
      format.js { head :ok }
      format.xml { head :ok }
    end
  end

  def preview
    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
    end
  end

  protected
  def category_params
    params[:category].permit(["name", "description", "parent_id", {"attribute_ids"=>[]},{"basic_attribute_ids"=>[]},"pic", "measures", "measure_properties","priority", "ranges", "order","banner_pic", "banner_pic_link"])
  end
end
