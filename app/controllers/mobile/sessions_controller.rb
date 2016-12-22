class Mobile::SessionsController < Mobile::ApplicationController
  def create
    logout_keeping_session!
    params[:account] ||= {:email => params[:email], :password => params[:password]} # compatible with old parameters
    @account = Core::Account.search_by_params((params[:account]||{}).slice(:id, :login, :email, :phone))

    if @account && @account.authenticated?(params[:account][:password])
      self.current_account = @account
      respond_to do |format|
        format.html { redirect_to params[:redirect] || root_path }
        format.xml { @data = {'account' => @account.assign_options(:only => [:id])} }
      end
    else
      logger.warn "Failed login for '#{params[:account][:login] || params[:account][:email] || params[:account][:phone]}' from #{request.remote_ip} at #{Time.now}"
      @login = params[:login]
      @remember_me = params[:remember_me]

      flash[:notice] = "用户名或密码输入错误"
      respond_to do |format|
        format.html { render :action => 'new' }
        format.xml { raise ArgumentError, "用户名或密码输入错误" }
      end
    end
  end

  def destroy
    logout_killing_session!

    respond_to do |format|
      format.html { redirect_to params[:redirect] || root_path }
      format.xml
    end
  end

  def authorized?
    @enable_lazyload = true
    return true if %w[create].include?(params[:action])
    @current_user = Shop::User.acquire(@current_user.id) if @current_user
    !!@current_user
  end
end
