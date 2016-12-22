class Admin::Shop::UsersController < Admin::Shop::ApplicationController
  def index # :nodoc:
    @users = Shop::User._where(params[:where])._order(params[:order]).where(!params[:email].blank? || !params[:phone].blank? ? "id IN(#{(Core::Account.scoped(:conditions => ["email = ? OR phone = ?", params[:email], params[:phone]]).map(&:id)+['null']).join(',')})" : nil).page(params[:page]).per(params[:per_page])
    # @users = [].paginate(:page => 1) unless @current_user.can?(:index, Shop::User.new) || @users.total_entries <= 1

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @users }
    end
  end

  # == Name
  #
  # 用户列表
  #
  # == Request
  #
  # === Resource
  #
  # GET /auction/manage/users/:id
  #
  # === Parameters
  #
  # id :: ID
  # page :: 页数
  # per_page :: 每页个数
  #
  # == Response
  #
  # === JSON
  #
  #   {
  #     "user" : {
  #       "id" : "ID",
  #       "mall_ids" : "商城ID列表，每行一个",
  #     }
  #   }
  #
  # === XML
  #
  # === YAML
  #
  def show
    @user = Shop::User.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { @data = {'user' => @user.assign_options(:only => [:id, :mall_ids])} }
      format.js { render :text => @user.to_json }
    end
  end

  def edit # :nodoc:
    @user = Shop::User.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @user }
    end
  end

  # == Name
  #
  # 用户列表
  #
  # == Request
  #
  # === Resource
  #
  # PUT /auction/manage/users/:id
  #
  # === Parameters
  #
  # id :: ID
  # user[mall_ids] :: 商城ID列表，每行一个
  #
  # == Response
  #
  # === JSON
  #
  #   {
  #     "user" : {
  #       "id" : "ID",
  #       "mall_ids" : "商城ID列表，每行一个",
  #     }
  #   }
  #
  # === XML
  #
  # === YAML
  #
  def update
    @user = Shop::User.find(params[:id])

    success = database_transaction do
      @user.attributes = params.require(:user).permit!.merge(:editor_id => @current_user.id)
      @user.update_trades_point_and_level_modified_at if @user.level_id_changed? || @user.level_keep == '1'
      @user.updatings.create!(@user.attributes.slice(*@changed_fields).merge(:editor_id => @current_user.id)) unless (@changed_fields = %w[trades_point level_id percent mall_ids remark].find_all { |field| @user.send("#{field}_changed?") }).blank?
      @user.save
      Core::User.find(@user.id).setting.update_attributes!(params.require(:setting).permit!.slice(:receive_promotion_email, :receive_promotion_email_of_event, :receive_promotion_email_of_voucher, :receive_promotion_email_of_news, :receive_promotion_email_of_recommend, :receive_promotion_sms_of_event, :receive_promotion_sms_of_voucher, :receive_promotion_sms_of_promote)) if params[:setting]
    end

    respond_to do |format|
      if success
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to admin_shop_user_path(@user) }
        format.js { head :ok }
        format.xml { @data = {'user' => @user.assign_options(:only => [:id, :mall_ids])} }
      else
        format.html { render :action => "edit" }
        format.js { raise }
        format.xml { raise }
      end
    end
  end

  def updatings
    @user = Shop::User.find(params[:id])
  end

  def batch
    @users=Shop::User.find(params[:ids].split(","))
    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
    end
  end

  def batch_update
    @success = database_transaction do
      # @users = Shop::User.where(id: params[:update_user_id].to_s.scan(/\d+/))
      @users = Shop::User.where(id: params[:ids].split(","))
      # if params[:update_field].to_s == 'update_label'
      #   options = {label: params[:update_old_label].to_s, id: params[:update_user_id].to_s.scan(/\d+/)}
      #   options = options.select { |k, v| v.present? } if options.values.any? { |v| v.present? }
      #   @users = @users.except(:where).where(options)
      # end
      @users.each do |user|
        attributes = case params[:update_field].to_s
                       when 'add_mall'
                         {mall_ids: (user.mall_ids.to_s.scan(/\d+/) | params[:update_mall_ids].scan(/\d+/)).join("\n")}
                       when 'delete_mall'
                         {mall_ids: (user.mall_ids.to_s.scan(/\d+/) - params[:update_mall_ids].scan(/\d+/)).join("\n")}
                       when 'update_label'
                         {label: params[:update_new_label].to_s}
                     end
        if attributes.is_a?(Hash)
          user.update_attributes!(attributes.merge(editor_id: @current_user.id))
          user.updatings.create!(attributes.merge(:editor_id => @current_user.id)) unless (attributes = attributes.slice(:trades_poin, :level_id, :percent, :mall_ids, :remark)).blank?
        end
      end
    end

    respond_to do |format|
      if @success
        format.html { redirect_to admin_shop_users_path }
        format.xml { head :ok }
      else
        format.html { redirect_to shop: :batch }
        format.xml { raise ArgumentError }
      end
    end
  end

  def update_shop_user_password
    return unless params[:shop_user].present?
    @shop_user = Shop::User.acquire(params[:shop_user][:id])
    @shop_user.editor_id = @current_user.id
    @shop_user.crypted_password = Core::Account.find(@shop_user.id).encrypt(params[:shop_user][:password]) if params[:shop_user][:password]
    @shop_user.save
  end

  def update_core_account_password
    return unless params[:core_account].present?
    @core_account = Core::Account.acquire(params[:core_account][:id])
    @core_account.password = params[:core_account][:password]
    @core_account.encrypt_password
    @core_account.save
  end

end
