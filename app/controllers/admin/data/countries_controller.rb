class Data::CountriesController < Data::ApplicationController

  def index
    @countries = Data::Country.active._where(params[:where])._order(params[:order]).paginate(:page => params[:page], :per_page => params[:per_page])
    @countries = [].paginate(:page => 1) unless @current_user.can?(:index, Data::Country.new) || @countries.total_entries <= 1

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @countries }
    end
  end

  def show
    @country = Data::Country.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @country }
    end
  end

  def new
    @country = Data::Country.new

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @country }
    end
  end

  def create
    @country = Data::Country.new(params[:country].merge(:user_id => @current_user.id))

    respond_to do |format|
      if @country.save
        flash[:notice] = 'Editor was successfully created.'
        format.html { redirect_to admin_shop_country_path(@country) }
        format.xml { render :xml => @country, :status => :created, :location => @country }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @country.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @country = Data::Country.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @country }
    end
  end

  def update
    @country = Data::Country.find(params[:id])

    respond_to do |format|
      if @country.update_attributes(params[:country])
        flash[:notice] = 'Editor was successfully updated.'
        format.html { redirect_to admin_shop_country_path(@country) }
        format.js { head :ok }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.js { raise }
        format.xml { render :xml => @country.errors, :status => :unprocessable_entity }
      end
    end
  end

  def publish
    @country = Data::Country.acquire(params[:id])
    @country.attributes = {:published => true, :user_id => @current_user.id}
    @country.save

    respond_to do |format|
      format.js { head @country.valid? ? :accepted : :bad_request }
    end
  end

  def unpublish
    @country = Data::Country.acquire(params[:id])
    @country.attributes = {:published => false, :user_id => @current_user.id}
    @country.save

    respond_to do |format|
      format.js { head @country.valid? ? :accepted : :bad_request }
    end
  end

  def destroy
    @country = Data::Country.find(params[:id])
    @country.destroy_softly

    respond_to do |format|
      format.html { redirect_to admin_shop_countries_path }
      format.xml { head :ok }
    end
  end
end
