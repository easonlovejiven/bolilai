class Admin::Shop::SynonymsController <  Admin::Shop::ApplicationController
	def index
		@synonyms = Shop::Synonym.active._where(params[:where])._order(params[:order]).paginate(:page => params[:page], :per_page => params[:per_page])
		@synonyms = [].paginate(:page => 1) unless @current_user.can?(:index, Shop::Synonym.new) || @synonyms.total_entries <= 1

		respond_to do |format|
			format.html { render :layout => false if request.xhr? }
			format.xml  { render :xml => @synonyms }
		end
	end

	def show
		@synonym = Shop::Synonym.find(params[:id])

		respond_to do |format|
			format.html { render :layout => false if request.xhr? }
			format.xml  { render :xml => @synonym }
		end
	end

	def new
		@synonym = Shop::Synonym.new

		respond_to do |format|
			format.html { render :layout => false if request.xhr? }
			format.xml  { render :xml => @synonym }
		end
	end

	def create

		@synonym = Shop::Synonym.new(params[:synonym].merge(:editor_id => @current_user.id))

		respond_to do |format|
			if @synonym.save
				flash[:notice] = 'Synonym was successfully created.'
				format.html { redirect_to admin_shop_synonym_path(@synonym) }
				format.xml  { render :xml => @synonym, :status => :created, :location => @synonym }
			else
				format.html { render :action => "new" }
				format.xml  { render :xml => @synonym.errors, :status => :unprocessable_entity }
			end
		end
	end

	def edit
		@synonym = Shop::Synonym.find(params[:id])

		respond_to do |format|
			format.html { render :layout => false if request.xhr? }
			format.xml  { render :xml => @synonym }
		end
	end

	def update
		@synonym = Shop::Synonym.find(params[:id])

		respond_to do |format|
			if @synonym.update_attributes(params[:synonym])
				flash[:notice] = 'Synonym was successfully updated.'
				format.html { redirect_to admin_shop_synonym_path(@synonym) }
				format.js { head :ok }
				format.xml  { head :ok }
			else
				format.html { render :action => "edit" }
				format.js { raise }
				format.xml  { render :xml => @synonym.errors, :status => :unprocessable_entity }
			end
		end
	end

	def destroy
		@synonym = Shop::Synonym.find(params[:id])
		@synonym.destroy_softly

		respond_to do |format|
			format.html { redirect_to admin_shop_synonyms_path }
			format.xml  { head :ok }
		end
	end

	def publish
		@brand = Shop::Synonym.acquire(params[:id])
		@brand.update_attribute(:published, true)
		Rails.cache.delete("views/#{HOSTS['dynamic']}/shop/synonyms.xml")

		respond_to do |format|
			format.html { redirect_to admin_shop_synonyms_path }
			format.js  { head :ok }
			format.xml  { head :ok }
		end
	end

	def unpublish
		@brand = Shop::Synonym.acquire(params[:id])
		@brand.update_attribute(:published, false)

		respond_to do |format|
			format.html { redirect_to admin_shop_synonyms_path }
			format.js  { head :ok }
			format.xml  { head :ok }
		end
	end

	def import
		Shop::Brand.active.published.scoped().each do |brand|
			[brand.name, brand.chinese, brand.abbreviation].each do |name|
				Shop::Synonym.create!(:name => name.to_s.strip, :brand_id => brand.id, :editor_id => @current_user.id) if !name.to_s.strip.blank? && !Shop::Synonym.active.find_by_name(name)
			end
		end
		Shop::Category.active.published.scoped(:conditions => "id != 1").each do |category|
			next if (name = category.name.to_s.strip).blank? || Shop::Synonym.active.find_by_name(name)
			next unless options = category.parent_id == 1 && { :category1_id => category.id } || category.parent && category.parent.parent_id == 1 && { :category2_id => category.id }
			Shop::Synonym.create!(options.merge(:name => name, :editor_id => @current_user.id))
		end
		respond_to do |format|
			flash[:notice] = 'Synonyms ware successfully created.'
			format.html { redirect_to admin_shop_synonyms_path }
			format.js  { head :ok }
			format.xml  { head :ok }
		end
	end

end
