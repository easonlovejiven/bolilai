class Data::ProvincesController < Data::ApplicationController

  def index
    @provinces = Data::Province.active._where(params[:where])._order(params[:order]).paginate(:page => params[:page], :per_page => params[:per_page])
    @provinces = [].paginate(:page => 1) unless @current_user.can?(:index, Data::Province.new) || @provinces.total_entries <= 1

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @provinces }
    end
  end

  def show
    @province = Data::Province.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @province }
    end
  end

  def new
    @province = Data::Province.new

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @province }
    end
  end

  def create

    @province = Data::Province.new(params[:province].merge(:user_id => @current_user.id))

    respond_to do |format|
      if @province.save
        flash[:notice] = 'Editor was successfully created.'
        format.html { redirect_to admin_shop_province_path(@province) }
        format.xml { render :xml => @province, :status => :created, :location => @province }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @province.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @province = Data::Province.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @province }
    end
  end

  def update
    @province = Data::Province.find(params[:id])

    respond_to do |format|
      if @province.update_attributes(params[:province])
        flash[:notice] = 'Editor was successfully updated.'
        format.html { redirect_to admin_shop_province_path(@province) }
        format.js { head :ok }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.js { raise }
        format.xml { render :xml => @province.errors, :status => :unprocessable_entity }
      end
    end
  end

  def publish
    @province = Data::Province.acquire(params[:id])
    @province.attributes = {:published => true, :user_id => @current_user.id}
    @province.save

    respond_to do |format|
      format.js { head @province.valid? ? :accepted : :bad_request }
    end
  end

  def unpublish
    @province = Data::Province.acquire(params[:id])
    @province.attributes = {:published => false, :user_id => @current_user.id}
    @province.save

    respond_to do |format|
      format.js { head @province.valid? ? :accepted : :bad_request }
    end
  end

  def destroy
    @province = Data::Province.find(params[:id])
    @province.destroy_softly

    respond_to do |format|
      format.html { redirect_to admin_shop_provinces_path }
      format.xml { head :ok }
    end
  end
end
