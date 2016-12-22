class Admin::Core::AccountsController < Admin::Core::ApplicationController

  def index
    @accounts = Core::Account.active._where(params[:where])._order(params[:order]).paginate(:page => params[:page], :per_page => params[:per_page])
    @accounts = [].paginate(:page => 1) unless @current_user.can?(:index, Core::Account.new) || @accounts.total_entries <= 1

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { head :ok }
      format.xls { render xls: export(records: @accounts, export: params[:export]) }
      format.csv { render csv: export(records: @accounts, export: params[:export]) }
      format.tsv { render tsv: export(records: @accounts, export: params[:export]) }
    end
  end

  def show
    @account = Core::Account.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { head :ok }
    end
  end

  def new
    render action: 'show'
  end

  def create
    success = database_transaction do
      defaults = {
          ip_address: request.remote_ip,
          client: 'manage',
          shop_id: @current_user.guide.try(:shop_id),
          password_confirmation: params[:core_account][:password],
      }
      @account = Core::Account.new
      @account.attributes = params[:core_account].to_h.slice(*%w[email phone password guide_id]).merge(defaults).reject { |key, value| value.blank? }
      @account.save!
      @account.activate!
      @account.activate_phone!
      @user = Core::User.new
      @user.id = @account.id
      @user.update_attributes!(params[:core_account].to_h['user_attributes'].to_h.slice(*%w[name sex]))
      @info = Core::Info.new
      @info.id = @account.id
      @info.save!
      @setting = Core::Setting.new
      @setting.id = @account.id
      @account.user = @user
      @account.info = @info
      @account.setting = @setting
      # @account = Core::Account.find(@user.id)
      # logger.info "\n\n#{@account.errors.to_a}\n\n#{@account.id}\n\n#{@user.id}\n\n\n\n"
      Shop::User.acquire(@user.id)
      Retail::User.acquire(@user.id)
      Data::User.acquire(@user.id)
    end

    if success
      respond_to do |format|
        format.html { render action: 'show' }
        format.js { render :text => '' }
        format.xml { @data = {'account' => @account.assign_options(:only => [:id])} }
      end
    else
      respond_to do |format|
        format.html { render action: 'show' }
        format.js { raise }
        format.xml { raise ActiveRecord::RecordInvalid.new(@account||Core::Account.new) }
      end
    end
  end

  def point_rank
    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
    end
  end

  def update_phone

    phones = ['18722005077', '15122071387', '13752148477', '15222842722', '13682011406', '18622186946', '13821833673', '13132113601']

    database_transaction do
      Core::Account.find_all_by_phone(phones).each do |account|
        account.update_attribute(:phone, [account.phone, Digest::SHA1.hexdigest(rand(10000).to_s+Time.now.to_s)[0..5]].join('_'))
      end
    end

    respond_to do |format|
      format.html { redirect_to(request.referer || manage_core_accounts_path) }
      format.xml { head :ok }
    end
  end

  def clear_ip

    database_transaction do
      Core::Account.active.find_all_by_ip_address('221.239.91.242').each do |account|
        account.update_attribute(:ip_address, nil)
      end
    end

    respond_to do |format|
      format.html { redirect_to(request.referer || manage_core_accounts_path) }
      format.xml { head :ok }
    end
  end

end
