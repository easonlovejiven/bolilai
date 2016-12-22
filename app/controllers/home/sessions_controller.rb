##
# = 主站 登录 界面
#
class Home::SessionsController < Home::ApplicationController
  ##
  # == 获得session
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /sessions
  #
  # ==== Parameters
  #
  # === Response
  #
  # ==== JSON
  #
  #   {
  #     "session_key": session,
  #     'secret': 私钥,
  #     'current_time': 当前时间,
  #     '@current_user': 当前用户,
  #     'is_cookie_supported': 是否支持cookie,
  #   }
  #
  def index
    respond_to do |format|
      format.html { redirect_to params[:redirect] || root_path }
      format.xml {
        @data = {
            'session_key' => (session.inspect; request.session_options[:id]),
            'secret' => (session[:secret] || (session[:secret] = form_authenticity_token)),
            'current_time' => Time.now.to_s(:db),
            '@current_user' => (@current_user && @current_user.id),
            'is_cookie_supported' => !!cookies[request.session_options[:key]],
        }
      }
    end
  end

  ##
  # == 帐号登录
  #
  # === Request
  #
  # ==== Resource
  #
  # POST /sessions
  #
  # ==== Parameters
  #
  # \account[id] :: 帐号ID
  # \account[login] :: 登录名，邮箱或手机
  # \account[email] :: 邮箱
  # \account[phone] :: 手机
  # \account[password] :: 密码
  # remember_me :: 是否记住密码，1为记住，0为不记住
  #
  # === Response
  #
  # ==== JSON
  #
  #   {
  #     "account" : {
  #       "id" : ID,
  #     }
  #   }
  #
  def create
    logout_keeping_session!
    params[:account] ||= {:email => params[:email], :password => params[:password]} # compatible with old parameters
    @account = Core::Account.search_by_params((params[:account]||{}).slice(:id, :login, :email, :phone))

    if @account && @account.authenticated?(params[:account][:password])
      self.current_account = @account
      respond_to do |format|
        format.html { redirect_to params[:redirect] || root_path }
        format.xml { @data = {'account' => @account.assign_options(:only => [:id]), user_id: @account.id} }
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

  ##
  # == 帐号退出
  #
  # === Request
  #
  # ==== Resource
  #
  # DELETE /sessions/:id
  #
  # ==== Parameters
  #
  # id :: 帐号ID
  # redirect :: 跳转地址
  #
  # === Response
  # ==== JSON
  #
  #   {
  #   }
  #
  def destroy
    logout_killing_session!
    respond_to do |format|
      format.html { redirect_to params[:redirect] || root_path }
      format.js { head :ok }
    end
  end

  private

  def authorized?
    true
  end
end
