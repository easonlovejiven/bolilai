class Admin::CustomPage::PagesController < Admin::ApplicationController
  def index
    # @pages = ::CustomPage::Page.active.joins("LEFT JOIN  custom_page_pages_pages ON custom_page_pages.id = custom_page_pages_pages.page_id").where("custom_page_pages_pages.page_id is not  null")._where(params[:where])._order(params[:order]).page(params[:page]).per(params[:per_page])
    params[:where]||={}
    params[:where][:tmpl]||=0
    @pages = ::CustomPage::Page.active._where(params[:where])._order(params[:order])
    @pages = @pages.page(params[:page]).per(params[:per_page]||20)
    # @pages = [].paginate(:page => 1) unless @current_user.can?(:index, ::CustomPage::Page.new) || @pages.total_entries <= 1

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { @data = {total_pages: @pages.total_pages,current_page: @pages.current_page,'pages' => @pages.map { |page| page.attributes.merge(snapshot: page.snapshot_image.url(:cover320)) }} }
      # format.json { render json: {'pages' => @pages.map{|page|page.to_json.merge!(snapshot: page.snapshot.url(:thumb))} }}
    end
  end

  def show
    @page = ::CustomPage::Page.acquire(params[:id])
    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
    end
  end

  def new
    @page = ::CustomPage::Page.new
    page_params = (page_params||{}).merge(@page.class.acquire(params[:id]).attributes).merge(:images_attributes => @page.class.acquire(params[:id]).images.map { |image| image.attributes.slice(*::CustomPage::PagesImage.manage_fields) }) if params[:id]
    @page.attributes = (page_params||{}).slice(*@page.class.manage_fields)

    respond_to do |format|
      format.html { render :action => 'show', :layout => false if request.xhr? }
    end
  end

  def create
    @page = ::CustomPage::Page.new
    images = params[:custom_page_page].delete(:images_attributes)
    if images.present?
      image_attributes=JSON.parse(images).map { |item| item.merge({"active" => true}) }
      @page.images_attributes=image_attributes
    end
    page_params[:pages_pages_attributes] = page_params[:pages_pages_attributes].sort_by { |key, attributes| key.to_i }.map { |key, attributes| attributes.slice(*(%w[id active] + ::CustomPage::PagesPage.manage_fields)) } if page_params && page_params[:pages_pages_attributes]
    @page.attributes = (page_params||{}).slice(*@page.class.manage_fields).merge(:editor_id => @current_user.id)
    @page.save

    respond_to do |format|
      format.html { redirect_to :action => 'index' }
    end
  end

  def edit
    @page = ::CustomPage::Page.acquire(params[:id])
    @page.attributes = (params[:custom_page_page]||{}).slice(*@page.class.manage_fields)

    respond_to do |format|
      format.html { render :action => 'show', layout: false if request.xhr? }
    end
  end

  def update
    @page = ::CustomPage::Page.acquire(params[:id])
    images = params[:custom_page_page].delete(:images_attributes)
    if images.present?
      image_attributes=JSON.parse(images).map { |item| item.merge({"active" => true}) }
      @page.images_attributes=image_attributes
    end
    page_params[:pages_pages_attributes] = page_params[:pages_pages_attributes].sort_by { |key, attributes| key.to_i }.map { |key, attributes| attributes.slice(*(%w[id active] + ::CustomPage::PagesPage.manage_fields)) } if page_params && page_params[:pages_pages_attributes]
    @page.attributes = (page_params||{}).slice(*@page.class.manage_fields).merge(:editor_id => @current_user.id)
    @page.save

    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      # format.js { head @page.valid? ? :accepted : :bad_request }
    end
  end

  def update_batch
    database_transaction do
      contents=JSON.parse(params[:custom_page_page][:content]||{})
      contents.each do |id, content|
        @page = ::CustomPage::Page.acquire(id)
        page_params[:pages_pages_attributes] = page_params[:pages_pages_attributes].sort_by { |key, attributes| key.to_i }.map { |key, attributes| attributes.slice(*(%w[id active] + ::CustomPage::PagesPage.manage_fields)) } if page_params && page_params[:pages_pages_attributes]
        @page.attributes = {content: content.to_json}.merge(:editor_id => @current_user.id)
        @page.save
      end
    end
    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      # format.js { head @page.valid? ? :accepted : :bad_request }
    end
  end

  def batch_delete
    @pages = ::CustomPage::Page.where(id: params[:ids].split(","))
    respond_to do |format|
      format.html { render template: 'admin/shared/batch_delete', locals: {records: @pages, del_url: admin_pages_path(:id => @pages.map(&:id).join(",")), unable_msg: '有所属父页面，无法删除？'}, :layout => false }
      format.xml { render :xml => @page }
    end
  end

  def delete
    @page = ::CustomPage::Page.acquire(params[:id])
    respond_to do |format|
      format.html { render template: 'admin/shared/delete', locals: {record: @page, unable_msg: '无法删除？'}, :layout => false }
    end
  end

  def destroy
    @pages = ::CustomPage::Page.where(id: params[:id].split(","))
    @pages.each do |page|
      page.attributes = {:active => false, :editor_id => @current_user.id}
      page.save
    end
    respond_to do |format|
      format.html { redirect_to :action => 'index', status: :ok }
    end
  end

  def publish
    @page = ::CustomPage::Page.acquire(params[:id])
    @page.attributes = {:published => true, :editor_id => @current_user.id}
    @page.save

    respond_to do |format|
      format.js { head @page.valid? ? :accepted : :bad_request }
    end
  end

  def unpublish
    @page = ::CustomPage::Page.acquire(params[:id])
    @page.attributes = {:published => false, :editor_id => @current_user.id}
    @page.save

    respond_to do |format|
      format.js { head @page.valid? ? :accepted : :bad_request }
    end
  end

  def preview
    @page = ::CustomPage::Page.acquire(params[:id])
    render :layout => false
  end

  def customizer
    @page = ::CustomPage::Page.new
    @page.engine = 'template'
    @page.content = <<-STR
      {
        "version": "blank",
        "style": {
          "background-color": "",
          "background-image": ""
        }
      }
    STR
    render :layout => false
  end

  def customize
    @page = ::CustomPage::Page.new
    page_params[:pages_pages_attributes].each { |key, attributes| attributes.merge!('child_id' => @page.class.create((@page.class.active.find_by_id(attributes['child_id'])||@page.class.new).attributes.slice(*@page.class.manage_fields).merge(page_params.slice(*%w[name series title])).merge(:editor_id => @current_user.id)).id).delete('_copy') if attributes['_copy'] } if page_params && page_params[:pages_pages_attributes]
    page_params[:images_attributes] = page_params[:images_attributes].sort_by { |key, attributes| key.to_i }.map { |key, attributes| attributes.slice(*(%w[id active] + ::CustomPage::PagesImage.manage_fields)) } if page_params && page_params[:images_attributes]
    page_params[:pages_pages_attributes].sort_by { |key, attributes| key.to_i }.map { |key, attributes| attributes.slice(*(%w[id active] + ::CustomPage::PagesPage.manage_fields)) } if page_params && page_params[:pages_pages_attributes]
    @page.attributes = (page_params||{}).slice(*@page.class.manage_fields).merge(:editor_id => @current_user.id)
    @page.save!

    respond_to do |format|
      format.html { redirect_to :action => 'index', :status => :ok }
      format.js { redirect_to :action => 'index', :status => :ok }
      # format.js { head :ok, info: '创建成功！' }
    end
  end

  def snapshoot
    @page = ::CustomPage::Page.acquire(params[:id])
    return if @page.content.blank?
    content = render_to_string(:file => "custom_page/pages/show",layout: false, :locals => {:page => @page})
    return if content.blank?
    file = Tempfile.new(['snapshots', '.jpg'])
    cont = {"cont" => Base64.encode64(content)}
    begin
      Timeout::timeout(60) { `phantomjs --disk-cache=no --ignore-ssl-errors=yes --load-images=yes #{Rails.root}/app/assets/javascripts/admin/custom_page/snapshoot.js.coffee #{file.path} '#{cont.to_json}'` }
    rescue Timeout::Error
      Rails.logger.info "Phantomjs is timeout #{Time.now}"
      return
    end
    img_url = file.path
    # image = MiniMagick::Image.open(img_url)
    # image.resize "320x"
    # image.write img_url
    @page.snapshot_image = open(img_url)
    @success = true if @page.save
    file.unlink
  end

  def page_params
    # params[:custom_page_page].permit(["name", "series", "title", "engine", "content", "snapshot", "position", "keywords", "description"])
    params.require(:custom_page_page).permit!
  end
end
