class Admin::Shop::LevelsController < Admin::Shop::ApplicationController
  def index
    @levels = ::Shop::Level.active._where(params[:where])._order(params[:order]).page(params[:page]).per(params[:per_page])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @levels }
    end
  end

  def show
    @level = ::Shop::Level.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @level }
    end
  end

  def new
    @level = ::Shop::Level.new

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @level }
    end
  end

  def create
    @level = ::Shop::Level.new(level_params.merge(:editor_id => @current_user.id))

    respond_to do |format|
      if @level.save
        flash[:notice] = '等级创建成功'
        format.html { redirect_to admin_shop_level_path(@level) }
        format.xml { render :xml => @level, :status => :created, :location => @level }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @level.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @level = ::Shop::Level.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @level }
    end
  end

  def update
    @level = ::Shop::Level.find(params[:id])

    respond_to do |format|
      if @level.update_attributes(level_params)
        flash[:notice] = '等级更新成功'
        format.html { redirect_to admin_shop_level_path(@level) }
        format.js { head :ok }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.js { raise }
        format.xml { render :xml => @level.errors, :status => :unprocessable_entity }
      end
    end
  end

  def delete
    @level = ::Shop::Level.find(params[:id])

    respond_to do |format|
      format.html { render template: 'admin/shared/delete', locals: {record: @level, unable_msg: '此等级无法删除？'}, :layout => false }
      format.xml { render :xml => @level }
    end
  end

  def destroy
    @level = ::Shop::Level.find(params[:id])
    @level.destroy_softly

    respond_to do |format|
      format.html { redirect_to admin_shop_levels_path, :status => :ok }
      format.xml { head :ok }
    end
  end

  protected

  def level_params
    params[:level].permit(["name", "description", "limitation", "reservation", "percent", "icon"])
  end
end
