class Admin::Cms::PagesController < Admin::ApplicationController
  def index
    @pages = ::Cms::Page.active._where(params[:where])._order(params[:order]).page(params[:page]).per(params[:per_page])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { @data = {'pages' => @pages} }
      format.json { render json: {'pages' => @pages} }
    end
  end

  def show
    @page = ::Cms::Page.acquire(params[:id])
    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
    end
  end

  def new
    @page = ::Cms::Page.new

    respond_to do |format|
      format.html { render :action => 'show', :layout => false if request.xhr? }
    end
  end

  def create
    @page = ::Cms::Page.new(page_params)
    @page.save

    respond_to do |format|
      format.html { redirect_to :action => 'index',status: :ok}
    end
  end

  def edit
    @page = ::Cms::Page.acquire(params[:id])

    respond_to do |format|
      format.html { render :action => 'show', layout: false if request.xhr? }
    end
  end

  def update
    @page = ::Cms::Page.acquire(params[:id])
    @page.update!(page_params)

    respond_to do |format|
      format.html { redirect_to :action => 'index',status: :ok}
      # format.js { head @page.valid? ? :accepted : :bad_request }
    end
  end

  def delete
    @page = ::Cms::Page.acquire(params[:id])

    respond_to do |format|
      format.html { render template: 'admin/shared/delete', locals: {record: @page, unable_msg: '该页面无法删除？'}, :layout => false }
      format.xml { render :xml => @page }
    end
  end

  def batch_delete
    @pages = ::Cms::Page.where(id: params[:ids].split(","))
    respond_to do |format|
      format.html { render template: 'admin/shared/batch_delete', locals: {records: @pages,del_url: admin_cms_pages_path(:id=>@pages.map(&:id).join(",")), unable_msg: '该页面无法删除？'}, :layout => false }
      format.xml { render :xml => @page }
    end
  end

  def destroy
    @pages = ::Cms::Page.where(id: params[:id].split(","))
    @pages.update_all({:active => false,:editor_id => @current_user.id})

    respond_to do |format|
      format.html { redirect_to :action => 'index',status: :ok }
    end
  end


  def publish
    @page = ::Cms::Page.acquire(params[:id])
    @page.update(:published => true, :editor_id => @current_user.id)

    respond_to do |format|
      format.js { head @page.valid? ? :accepted : :bad_request }
    end
  end

  def unpublish
    @page = ::Cms::Page.acquire(params[:id])
    @page.update(:published => false, :editor_id => @current_user.id)

    respond_to do |format|
      format.js { head @page.valid? ? :accepted : :bad_request }
    end
  end

  def preview
    @page = ::Cms::Page.acquire(params[:id])
    render :layout => false
  end

  private

  def page_params
    params[:cms_page].permit(["name", "category_id", "template_type", "url", "background", "position", 'body', 'active', 'tag_list' => []])
  end
end
