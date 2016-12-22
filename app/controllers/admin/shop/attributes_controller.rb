class Admin::Shop::AttributesController < Admin::Shop::ApplicationController
  def index
    @attributes = ::Shop::Attribute.active._where(params[:where])._order(params[:order]).page(params[:page]).per(params[:per_page])
    # @attributes = [].paginate(:page => 1) unless @current_user.can?(:index, :product_attribute) || @attributes.total_entries <= 1

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @attributes }
    end
  end

  def show
    @attribute = ::Shop::Attribute.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @attribute }
    end
  end

  def new
    @attribute = ::Shop::Attribute.new

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @attribute }
    end
  end

  def create
    @attribute = ::Shop::Attribute.new(attrs_params.merge(:editor_id => @current_user.id))

    respond_to do |format|
      if @attribute.save
        flash[:notice] = 'Attribute was successfully created.'
        format.html { redirect_to admin_shop_attribute_path(@attribute) }
        format.xml { render :xml => @attribute, :status => :created, :location => @attribute }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @attribute = ::Shop::Attribute.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @attribute }
    end
  end

  def update
    @attribute = ::Shop::Attribute.find(params[:id])

    respond_to do |format|
      if @attribute.update_attributes(attrs_params)
        flash[:notice] = 'Attribute was successfully updated.'
        format.html { redirect_to admin_shop_attribute_path(@attribute) }
        format.js { head :ok }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.js { raise }
        format.xml { render :xml => @attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  def delete
    @attribute = ::Shop::Attribute.find(params[:id])

    respond_to do |format|
      format.html { render template: 'admin/shared/delete', locals: {record: @attribute, unable_msg: '有被产品选择而无法删除？'}, :layout => false }
      format.xml { render :xml => @attribute }
    end
  end

  def destroy
    @attribute = ::Shop::Attribute.find(params[:id])

    unless @attribute.deletable?
      not_authorized
      return
    end

    @attribute.destroy_softly

    respond_to do |format|
      format.html { redirect_to admin_shop_attributes_path, :status => :ok }
      format.xml { head :ok }
    end
  end

  protected

  def attrs_params
    params[:attribute].permit(:name, :option_list, :searchable)
  end
end
