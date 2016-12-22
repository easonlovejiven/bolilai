class Admin::Shop::CouponsController < Admin::Shop::ApplicationController

  def index
    @coupons = ::Shop::Coupon.active._where(params[:where])._order(params[:order]).page(params[:page]).per(params[:per_page])
    # @coupons = [].paginate(:page => 1) unless @current_user.can?(:index, ::Shop::Coupon.new) || @coupons.total_entries <= 1

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @coupons }
    end
  end

  def show
    @coupon = ::Shop::Coupon.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @coupon }
    end
  end

  def new
    @coupon = ::Shop::Coupon.new

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @coupon }
    end
  end

  def create
    @coupon = ::Shop::Coupon.new(coupon_params.merge(:editor_id => @current_user.id, :event_ids => (coupon_params[:event_ids] || []).join("\n").strip))

    respond_to do |format|
      if @coupon.save
        flash[:notice] = 'Editor was successfully created.'
        format.html { redirect_to admin_shop_coupon_path(@coupon) }
        format.xml { render :xml => @coupon, :status => :created, :location => @coupon }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @coupon.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @coupon = ::Shop::Coupon.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @coupon }
    end
  end

  def update
    @coupon = ::Shop::Coupon.find(params[:id])

    respond_to do |format|
      if @coupon.update_attributes(coupon_params.merge(:event_ids => (coupon_params[:event_ids] || []).join("\n").strip))
        flash[:notice] = 'Editor was successfully updated.'
        format.html { redirect_to admin_shop_coupon_path(@coupon) }
        format.js { head :ok }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.js { raise }
        format.xml { render :xml => @coupon.errors, :status => :unprocessable_entity }
      end
    end
  end

  def delete
    @coupon = ::Shop::Coupon.find(params[:id])

    respond_to do |format|
      format.html { render template: 'admin/shared/delete', locals: {record: @coupon, unable_msg: '此优惠劵无法删除？'}, :layout => false }
      format.xml { render :xml => @coupon }
    end
  end

  def destroy
    @coupon = ::Shop::Coupon.find(params[:id])
    @coupon.destroy_softly

    respond_to do |format|
      format.html { redirect_to admin_shop_coupons_path }
      format.xml { head :ok }
    end
  end

  def publish
    @coupon = ::Shop::Coupon.acquire(params[:id])
    @coupon.update_attribute(:published, true)

    respond_to do |format|
      format.html { redirect_to admin_shop_coupons_path }
      format.js { head :ok }
      format.xml { head :ok }
    end
  end

  def unpublish
    @coupon = ::Shop::Coupon.acquire(params[:id])

    # if @coupon.published? && @coupon.started_at && Time.now > @coupon.started_at
    # 			not_authorized
    # 			return
    # 		end

    @coupon.update_attribute(:published, false)

    respond_to do |format|
      format.html { redirect_to admin_shop_coupons_path }
      format.js { head :ok }
      format.xml { head :ok }
    end
  end

  protected

  def coupon_params
    params["coupon"].permit(["code", "name", "description", "started_at", "ended_at", "limitation", "function", "point"])
  end

end
