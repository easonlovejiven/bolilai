class Admin::Shop::ContactsController < Admin::Shop::ApplicationController

  def index
    @contacts = Shop::Contact._where(params[:where])._order(params[:order]).page(params[:page]).per(params[:per_page])
    # @contacts = [].paginate(:page => 1) unless @current_user.can?(:index, Shop::Contact) || @contacts.total_entries <= 1

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { @data = @contacts }
      format.js { render :text => @contacts.to_json }
    end
  end

  def show
    @contact = Shop::Contact.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @contact }
    end
  end

  def new
    @contact = Shop::Contact.new

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @contact }
    end
  end

  def create
    @contact = Shop::Contact.new(params.require(:contact).permit!.merge(:editor_id => @current_user.id))

    respond_to do |format|
      if @contact.save
        flash[:notice] = 'Contact was successfully created.'
        format.html { redirect_to admin_shop_contact_path(@contact) }
        format.xml { render :xml => @contact }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @contact }
      end
    end
  end

  def edit
    @contact = Shop::Contact.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @contact }
    end
  end

  def update
    @contact = Shop::Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params.require(:contact).permit!.slice(:delivery_service, :remark))
        flash[:notice] = 'Contact was successfully updated.'
        format.html { redirect_to admin_shop_contact_path(@contact) }
        format.js { head :ok }
        format.xml { render :xml => @contact }
      else
        format.html { render :action => "edit" }
        format.js { raise }
        format.xml { render :xml => @contact }
      end
    end
  end

end
