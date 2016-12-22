class Admin::Shop::EventsController < Admin::Shop::ApplicationController
	def index
		@events = Shop::Event.active._where(params[:where])._order(params[:order]).page(params[:page]).per(params[:per_page])

		respond_to do |format|
			format.html { render :layout => false if request.xhr? }
			format.xml  { render :xml => @events }
			format.csv  { response.headers['Content-Disposition'] = 'attachment; filename=events.csv'; render :layout => false }
		end
	end

	def show
		@event = Shop::Event.acquire(params[:id])

		respond_to do |format|
			format.html { render :layout => false if request.xhr? }
			format.xml  { render :xml => @event }
		end
	end

	def new
		@event = Shop::Event.new

		respond_to do |format|
			format.html { render :layout => false if request.xhr? }
			format.xml  { render :xml => @event }
		end
	end

	def create
		@event = Shop::Event.new(event_params.merge(:editor_id => @current_user.id))

		respond_to do |format|
			if @event.save
				flash[:notice] = 'Editor was successfully created.'
				format.html { redirect_to admin_shop_event_path(@event),:status => :ok }
				format.xml  { render :xml => @event, :status => :created, :location => @event }
			else
				format.html { render :action => "new" }
				format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
			end
		end
	end

	def edit
		@event = Shop::Event.acquire(params[:id])

		respond_to do |format|
			format.html { render :layout => false if request.xhr? }
			format.xml  { render :xml => @event }
		end
	end

	def update
		@event = Shop::Event.acquire(params[:id])

		respond_to do |format|
			if @event.update_attributes(event_params.slice(:name, :description, :price, :started_at, :ended_at, :genre))
				flash[:notice] = 'Editor was successfully updated.'
				format.html { redirect_to admin_shop_event_path(@event) }
				format.js { head :ok }
				format.xml  { head :ok }
			else
				format.html { render :action => "edit" }
				format.js { raise }
				format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
			end
		end
	end

	def destroy
		@event = Shop::Event.acquire(params[:id])

		if @event.started_at && Time.now > @event.started_at
			not_authorized
			return
		end

		@event.destroy_softly

		respond_to do |format|
			format.html { redirect_to admin_shop_events_path,:status => :ok }
			format.xml  { head :ok }
		end
	end

	def publish
		@event = Shop::Event.acquire(params[:id])
		@event.update_attribute(:published, true)
		Rails.cache.delete("views/#{HOSTS['dynamic']}/shop/events.xml?page=1&per_page=9999.xml")

		respond_to do |format|
			format.html { redirect_to admin_shop_events_path }
			format.js  { head :ok }
			format.xml  { head :ok }
		end
	end

	def unpublish
		@event = Shop::Event.acquire(params[:id])
		@event.update_attribute(:published, false)

		respond_to do |format|
			format.html { redirect_to admin_shop_events_path }
			format.js  { head :ok }
			format.xml  { head :ok }
		end
  end

  private
  def event_params
    params.require(:event).permit ["name", "description", "limitation", "amount", "price", "started_at", "ended_at"]
  end
end
