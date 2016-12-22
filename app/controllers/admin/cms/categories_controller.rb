class Admin::Cms::CategoriesController < Admin::Cms::ApplicationController

  def index
    # @categories = ::Cms::Category._where(params[:where])._order(params[:order]).page(params[:page]).per(params[:per_page])
    # @categories = [].paginate(:page => 1) unless @current_user.can?(:index, ::Cms::Category.new) || @categories.total_entries <= 1
    @categories=[]
    ::Cms::Category.active._where(params[:where]).where(:parent_id => nil).each do |p|
      @categories.concat(p.self_and_descendants.active)
    end
    @categories = Kaminari.paginate_array(@categories).page(params[:page]).per(params[:per_page])
    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @categories }
    end
  end

  def show
    @category = ::Cms::Category.acquire(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @category }
    end
  end

  def new
    @category = ::Cms::Category.new

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @category }
    end
  end

  def create
    success = database_transaction do
      # @category = ::Cms::Category.new(category_params.merge(:user_id => @current_user.id))
      @category = ::Cms::Category.new(category_params)
      @category.save!
      # ErpRecord.connection.execute("INSERT INTO ruby_message(type, update_type, update_id, add_time, update_time) VALUES('CAT', 'INSERT', #{@category.id}, #{Time.now.to_i}, #{Time.now.to_i});") rescue nil
    end

    respond_to do |format|
      if success
        flash[:notice] = 'category was successfully created.'
        format.html { redirect_to admin_shop_categories_path, :status => :ok }
        format.xml { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @category = ::Cms::Category.find(params[:id])
    @kclass=::Cms::Category
    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @category }
    end
  end

  def update
    success = database_transaction do
      @category = ::Cms::Category.find(params[:id])
      @category.update_attributes!(category_params)
      ErpRecord.connection.execute("INSERT INTO ruby_message(type, update_type, update_id, add_time, update_time) VALUES('CAT', 'UPDATE', #{@category.id}, #{Time.now.to_i}, #{Time.now.to_i});") rescue nil
    end

    respond_to do |format|
      if success
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to admin_shop_categories_path, :status => :ok }
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
    @category = ::Cms::Category.find(params[:id])

    respond_to do |format|
      format.html { render template: 'admin/shared/delete', locals: {record: @category, unable_msg: '有被页面选择而无法删除？'}, :layout => false }
      format.xml { render :xml => @category }
    end
  end

  def publish
    @category = ::Cms::Category.acquire(params[:id])
    @category.update(published: true)

    respond_to do |format|
      format.html { redirect_to admin_shop_categories_path, :status => :ok }
      format.js { head :ok }
      format.xml { head :ok }
    end
  end

  def unpublish
    @category = ::Cms::Category.acquire(params[:id])
    @category.update(published: false)

    respond_to do |format|
      format.html { redirect_to admin_shop_categories_path, :status => :ok }
      format.js { head :ok }
      format.xml { head :ok }
    end
  end

  def batch_delete
    @categories = ::Cms::Category.where(id: params[:ids].split(","))
    respond_to do |format|
      format.html { render template: 'admin/shared/batch_delete', locals: {records: @categories,del_url: admin_cms_categories_path(:id=>@categories.map(&:id).join(",")), unable_msg: '该页面无法删除？'}, :layout => false }
      format.xml { render :xml => @category }
    end
  end

  def destroy
    @categories = ::Cms::Category.where(id: params[:id].split(","))
    @categories.update_all({:active => false})

    respond_to do |format|
      format.html { redirect_to :action => 'index',status: :ok }
    end
  end

  def preview
    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
    end
  end

  protected
  def category_params
    params[:category].permit(["name", "description", "template_type", "url", "parent_id", "attribute_ids", "pic",
                              "measures", "measure_properties", "published", "side_content", "is_page", "body"])
  end
end
