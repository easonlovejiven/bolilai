class Admin::Shop::CitiesController < Admin::Shop::ApplicationController

  def index
    @cities = Data::City.active._where(params[:where])._order(params[:order]).page(params[:page]).per(params[:per_page])
    @cities = [].paginate(:page => 1) unless @current_user.can?(:index, Data::City.new) || @cities.total_entries <= 1

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @cities }
    end
  end

  def show
    @city = Data::City.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @city }
    end
  end

  def new
    @city = Data::City.new

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @city }
    end
  end

  def create
    @city = Data::City.new(params[:city].merge(:user_id => @current_user.id))

    respond_to do |format|
      if @city.save
        flash[:notice] = 'Editor was successfully created.'
        format.html { redirect_to admin_shop_city_path(@city) }
        format.xml { render :xml => @city, :status => :created, :location => @city }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @city.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @city = Data::City.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @city }
    end
  end

  def update
    @city = Data::City.find(params[:id])

    respond_to do |format|
      if @city.update_attributes(params[:city])
        flash[:notice] = 'Editor was successfully updated.'
        format.html { redirect_to admin_shop_city_path(@city) }
        format.js { head :ok }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.js { raise }
        format.xml { render :xml => @city.errors, :status => :unprocessable_entity }
      end
    end
  end

  def publish
    @city = Data::City.acquire(params[:id])
    @city.attributes = {:published => true, :user_id => @current_user.id}
    @city.save

    respond_to do |format|
      format.js { head @city.valid? ? :accepted : :bad_request }
    end
  end

  def unpublish
    @city = Data::City.acquire(params[:id])
    @city.attributes = {:published => false, :user_id => @current_user.id}
    @city.save

    respond_to do |format|
      format.js { head @city.valid? ? :accepted : :bad_request }
    end
  end

  def destroy
    @city = Data::City.find(params[:id])
    @city.destroy_softly

    respond_to do |format|
      format.html { redirect_to admin_shop_cities_path }
      format.xml { head :ok }
    end
  end
end
