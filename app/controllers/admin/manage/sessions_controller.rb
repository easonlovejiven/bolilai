class Admin::Manage::SessionsController < Admin::Manage::ApplicationController

  def create
    logout_keeping_session!
    @editor = ::Manage::Editor.active.find_by(identifier: params[:account][:login])
    @account = @editor.account
    if @account.authenticated?(params[:account][:password])
      self.current_account = @editor.account

      respond_to do |format|
        format.html { redirect_to params[:redirect] || root_path }
        format.xml { @data = {'account' => @editor.account} }
      end
    else
      logger.warn "Failed login for '#{params[:account][:login]}' from #{request.remote_ip} at #{Time.now}"
      @login = params[:login]
      @remember_me = params[:remember_me]

      flash[:notice] = "用户名或密码输入错误"
      respond_to do |format|
        format.html { render :action => 'new' }
        format.json { raise ArgumentError, "用户名或密码输入错误" }
      end
    end
  end

  private

  def authorized?
    true
  end
end
