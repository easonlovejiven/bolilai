##
# = 主站 注册 界面
#
class Home::AccountsController < Home::ApplicationController
  include SimpleCaptcha::ControllerHelpers
  include SimpleCaptcha::ViewHelpers

  ##
  # == 新建
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /accounts/new
  #
  # ==== Parameters
  #
  # \invitation[id] :: 邀请ID
  # \invitation[code] :: 邀请码
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <invitation>
  #       <id type="integer">ID</id>
  #       <email>邮件</email>
  #       <app_id type="integer">应用ID</app_id>
  #       <user_id type="integer">邀请人ID</user_id>
  #       <invitee_id type="integer">被邀请ID</invitee_id>
  #       <created_at type="datetime">创建时间</created_at>
  #       <updated_at type="datetime">更新时间</updated_at>
  #       <user>
  #         <id type="integer">ID</id>
  #         <name>姓名</name>
  #         <sex>性别</sex>
  #         <pic>头像</pic>
  #       </user>
  #       <invitee>
  #         <id type="integer">ID</id>
  #         <name>姓名</name>
  #         <sex>性别</sex>
  #         <pic>头像</pic>
  #       </invitee>
  #     </invitation>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #     "invitation" : {
  #       "id" : ID,
  #       "email" : 邮件,
  #       "user_id" : 邀请人ID,
  #       "invitee_id" : 被邀请ID,
  #       "created_at" : 创建时间,
  #       "updated_at" : 更新时间,
  #       "user" : {
  #         "id" : ID,
  #         "name" : 姓名,
  #         "sex" : 性别,
  #         "pic" : 头像,
  #       },
  #       "invitee" : {
  #         "id" : ID,
  #         "name" : 姓名,
  #         "sex" : 性别,
  #         "pic" : 头像,
  #       },
  #     },
  #   }
  #
  def new
    @account = Core::Account.new
    @invitation = Core::Invitation.find_by_id(params[:invitation][:id]) if params[:invitation] && params[:invitation][:id]
    @invitation = nil if @invitation && (@invitation.invitee_id || (@invitation.code != params[:invitation][:code] if params[:invitation]))

    respond_to do |format|
      format.html
      format.xml { @data = {:invitation => @invitation} }
    end
  end

  ##
  # == 创建
  #
  # === Request
  #
  # ==== Resource
  #
  # POST /accounts
  #
  # ==== Parameters
  #
  # \account[email] :: 邮箱，邮箱和手机至少填一个 *
  # \account[phone] :: 手机 *
  # \account[password] :: 密码
  # \account[password_confirmation] :: 确认密码
  # \account[referrer_id] :: 介绍人ID
  # \account[source] :: 来源
  # \account[information] :: 附加信息
  # \user[name] :: 姓名
  # \user[sex] :: 性别
  # \user[birthday] :: 生日
  # \invitation[id] :: 邀请id
  # \invitation[code] :: 邀请码
  # \registration[code] :: 注册码，已停用
  # \coupon[code] :: 优惠券代码
  # \coupon[source] :: 优惠来源，例如sfexpress
  # \coupon[subcode] :: 优惠券子码
  # \account[client] :: 客户端类型, 必须为 %w[manage html5 osx windows linux flash iphone ipad android phone_web ipad_web wechat] 之一
  # captcha :: 验证码，根据show判断是否必填
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <account>
  #       <id type="integer">ID</id>
  #     </account>
  #   </response>
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

    need_registration_code = false
    need_validate_captcha = true

    @invitation = Core::Invitation.find_by_id(params[:invitation][:id]) if params[:invitation] && params[:invitation][:id]
    @invitation = nil if @invitation && (@invitation.code != params[:invitation][:code] || @invitation.invitee_id)

    @registration = Core::Registration.find_by_code(params[:registration][:code]) if params[:registration] && params[:registration][:code]
    @registration = nil if @registration && (!@registration.active? || @registration.account_id)

    if need_registration_code && !@invitation && !@registration
      not_authorized
      return
    end

    success = database_transaction do
      raise "未填邮箱或手机" if !params[:account] || params[:account][:email].blank? && params[:account][:phone].blank?
      raise '验证码错误' if need_validate_captcha && !(params[:captcha] && simple_captcha_valid?) #|| !Core::Account.need_captcha?(request.remote_ip)
      # params[:account][:email] = "#{params[:account][:phone]}@barlar.cn" if params[:account][:email].blank?
      @account = Core::Account.new((params[:account]||{}).permit!.slice(:email, :phone, :password, :password_confirmation, :referrer_id, :source, :infomation, :client).merge(cookies.instance_variable_get('@cookies').slice(*%w[link_id click_id latest_link_id latest_click_id])))
      @account.make_phone_activation_code
      @account.make_activation_code
      @account.save!
      @user = Core::User.new
      @user.id = @account.id
      @user.update_attributes!((params[:user].permit!||{}).slice(:name, :sex, :birthday))
      @info = Core::Info.new
      @info.id = @account.id
      @info.save!
      @setting = Core::Setting.new
      @setting.id = @account.id
      @setting.update_attributes!(:search_engine_indexing => true)
      @account.user = @user
      @account.info = @info
      @account.setting = @setting
      Shop::User.acquire(@user.id)
      # Retail::User.acquire(@user.id)
      # Data::User.acquire(@user.id)
    end

    if success
      # {"account"=>{"client"=>"html5", "phone"=>"13121684460", "password"=>"123123", "password_confirmation"=>"123123"},
      #  "redirect"=>"/", "user_signup_login_is"=>"", "user"=>{"name"=>"lizy", "sex"=>"male"}, "captcha"=>"2812", "controller"=>"home/accounts", "action"=>"create", "format"=>"xml", "_format"=>:json}
      self.current_account = @account # if @account.email && !@account.password.blank?
      @account.send_active_sms if @account.has_phone
      @account.send_active_email if @account.has_email
      @registration.update_attribute(:account_id, @account.id) if @registration

      if @invitation
        @invitation.invitee_id = @account.id
        @invitation.save
        @invitation.user.become_a_friend_of(@invitation.invitee)

        Talk::Notification.deliver(
            :receiver => @invitation.invitee,
            :content => "您已经和#{@invitation.user.name}成为好友。"
        )
        if @invitation.user.setting.i_invited_joins_facebook?
          Talk::Notification.deliver(
              :receiver => @invitation.user,
              :content => <<-TEXT
亲爱的#{@invitation.user.name}，您好：
　　您邀请的#{@invitation.invitee.name}已经成为您的好友。请及时查看。
          TEXT
          )
          Core::Mailer.mail(
              :recipients => @invitation.user.account.email,
              :subject => %[#{@invitation.invitee.name} 已经接受您的邀请加入珀丽莱],
              :template => 'joined',
              :body => {:invitee => @invitation.invitee, :user => @invitation.user}
          )
        end
      end

      if params[:coupon] && params[:coupon][:code] && (@coupon = Shop::Coupon.active.published.find_by_code(params[:coupon][:code])) && @coupon.available?
        @coupon.use_by(@user)
      end

      if params[:coupon] && params[:coupon][:source] && params[:coupon][:subcode].to_s.match(/^\d{6}$/) && (@coupon = Shop::Coupon.active.find_by_code(params[:coupon][:source]))
        @coupon.use_by(@user)
        @coupon.usages.where(user_id: @user.id).first.update_attributes(subcode: params[:coupon][:subcode])
      end

      respond_to do |format|
        format.html { redirect_to params[:redirect] || shop_markets_path }
        format.js { render :text => '' }
        format.xml { @data = {'account' => @account.assign_options(:only => [:id])} }
      end
    else
      respond_to do |format|
        format.html { redirect_to '/signup' }
        format.js { raise }
        format.xml { raise ActiveRecord::RecordInvalid.new(@account||Core::Account.new) }
      end
    end
  end

  def password
    not_authorized unless @current_user
    @account = current_account
  end

  ##
  # == 更新
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /accounts/:id
  #
  # ==== Parameters
  #
  # 以下参数4选一
  # id :: 帐号ID，不确定时传0
  # \account[login] :: 登录名，邮箱或手机
  # \account[email] :: 邮箱
  # \account[phone] :: 手机
  #
  # 以下两者二选一
  # \account[reset_code] :: 重置码
  # \account[old_password] :: 原密码
  #
  # 以下必传
  # \account[password] :: 新密码 *
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #   }
  #
  def update
    @account = Core::Account.search_by_params((params[:account]||{}).slice(:login, :email, :phone).merge(:id => params[:id]))

    password = params[:account] && params[:account][:password]
    old_password = params[:account] && params[:account][:old_password]
    reset_code = params[:account] && params[:account][:reset_code]

    unless password && old_password && !old_password.blank? && @account.authenticated?(old_password) || password && reset_code && !reset_code.blank? && @account.reset_code_valid?(reset_code)
      respond_to do |format|
        format.html { redirect_to request.referer || home_path }
        format.xml { raise ArgumentError }
      end
    end

    @account.password = @account.password_confirmation = password
    @account.remember_token = nil
    @account.remember_token_expires_at = nil

    if @account.save
      @account.updated if @account.changed?

      respond_to do |format|
        format.html { redirect_to request.referer || "/" }
        format.xml
      end
    else
      respond_to do |format|
        format.html { redirect_to (request.referer || "/") && return }
        format.xml { ActiveRecord::RecordInvalid.new(@account) }
      end
    end
  end

  # [PUT] "/core/accounts/0/update_email_and_password.json"
  def update_email_and_password
    @account = @current_account

    password = params[:core_account] && params[:core_account][:password]
    email = params[:core_account] && params[:core_account][:email]
    old_password = params[:core_account] && params[:core_account][:old_password]
    password_confirmation = params[:core_account] && params[:core_account][:repassword]

    @account.email  = email
    @account.password = password
    @account.remember_token = nil
    @account.remember_token_expires_at = nil

    if @account.save
      respond_to do |format|
        format.html { redirect_to request.referer || "/" }
        format.xml
      end
    else
      respond_to do |format|
        format.html { redirect_to (request.referer || "/") && return }
        format.xml { ActiveRecord::RecordInvalid.new(@account) }
      end
    end
  end

  ##
  # == 激活帐号并实现登录
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /accounts/:id/activate
  #
  # ==== Parameters
  #
  # id :: 帐号ID，不确定时传0
  # \account[login] :: 登录名，邮箱或手机
  # \account[email] :: 邮箱
  # \account[phone] :: 手机
  # \account[activation_code] :: 激活码 *
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #   }
  #
  def activate
    logout_keeping_session!
    @account = Core::Account.search_by_params((params[:account]||{}).slice(:login, :email, :phone).merge(:id => params[:id]))
    success = unless params[:account][:phone] || params[:account][:login] && !params[:account][:login].include?('@')
                if params[:account][:activation_code] == @account.activation_code
                  if first_active = !@account.activated_at
                    @account.activate!
                    #@account.send_active_success_email
                  end
                  true
                else
                  false
                end
              else
                if @account.phone_code_valid?(params[:account][:activation_code])
                  if first_active = !@account.phone_activated_at
                    @account.activate_phone!
                    #@account.send_active_success_sms
                  end
                  true
                else
                  false
                end
              end

    if success
      self.current_account = @account

      respond_to do |format|
        format.html { redirect_to '/' }
        format.xml
      end
    else
      respond_to do |format|
        format.xml { raise WEIMALL::InvalidActivationCodeError }
      end
    end
  end

  ##
  # == 重新发送激活码
  #
  # === Request
  #
  # ==== Resource
  #
  # POST /accounts/resend_activation_code
  #
  # ==== Parameters
  #
  # \account[login] :: 登录名，邮箱或手机
  # \account[email] :: 邮箱
  # \account[phone] :: 手机
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #   }
  #
  def resend_activation_code
    @account = Core::Account.search_by_params((params[:account]||{}).slice(:login, :email, :phone))

    if params[:account][:email] || params[:account][:login] && params[:account][:login].include?('@')
      #email
      @account.make_activation_code
      @account.save
      @account.send_active_email
    else
      #phone
      @account.make_phone_activation_code
      @account.save
      @account.send_active_sms
    end

    respond_to do |format|
      format.html { redirect_to :action => 'edit', :id => @account.id }
      format.xml
    end
  end

  ##
  # == 发送重置码
  #
  # === Request
  #
  # ==== Resource
  #
  # POST /accounts/reset
  #
  # ==== Parameters
  #
  # \account[login] :: 登录名，邮箱或手机
  # \account[email] :: 邮箱
  # \account[phone] :: 手机
  # captcha :: 验证码 *
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #   }
  #
  def reset
    @account = Core::Account.search_by_params((params[:account]||{}).slice(:login, :email, :phone))

    if @account && simple_captcha_valid?
      @account.make_reset_code

      if params[:account][:email] || params[:account][:login] && params[:account][:login].include?('@')
        Core::Mailer.mail(
            :recipients => @account.email,
            :subject => "珀丽莱密码重置",
            :template => 'reset',
            :body => {:account => @account}
        )
      else
        Shop::Sms.create!(:user_id => @account.id, :phone => @account.phone, :content => @account.remember_token, :active => false).send_by!(:re_password, nil)
      end

      respond_to do |format|
        format.html { redirect_to :action => 'edit', :id => @account.id }
        format.js { render :text => "" }
        format.xml
      end
    else
      respond_to do |format|
        format.html { redirect_to :action => 'edit', :id => @account.id }
        format.js { raise }
        format.xml { raise ArgumentError, "" }
      end
    end
  end

  ##
  # == 验证重置码是否有效
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /accounts/:id/validate_reset_code
  #
  # ==== Parameters
  #
  # reset_code :: 重置码 *
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <is_valid>是否有效</is_valid>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #     "is_valid": 是否有效,
  #   }
  #
  def validate_reset_code
    @account = Core::Account.find(params[:id])
    respond_to do |format|
      format.xml { @data = {'is_valid' => @account.reset_code_valid?(params[:reset_code])} }
    end
  end

  ##
  # == 查看账户状态
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /accounts/:id
  #
  # ==== Parameters
  #
  # id :: 帐号ID，不确定时传0，当id=0且以下参数都不传时返回当前登录用户
  # \account[login] :: 登录名
  # \account[email] :: 邮箱
  # \account[phone] :: 手机
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <account>
  #       <id type="integer">ID</id>
  #       <has_password type="boolean">是否填写密码</has_password>
  #       <has_email type="boolean">是否填写电子邮件</has_email>
  #       <has_phone type="boolean">是否填写手机号</has_email>
  #       <is_email_activated type="boolean">电子邮件是否激活</is_phone_activated>
  #       <is_phone_activated type="boolean">手机号是否激活</is_phone_activated>
  #       <connections type="Core::Connection">
  #         <connection type="array">
  #           <site>connect网站</site>
  #         </connection>
  #       </connections>
  #     </account>
  #     <need_captcha>注册时是否需要验证码</need_captcha>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #     "account" : {
  #       "id" : ID,
  #       "has_password" : 是否填写密码,
  #       "has_email" : 是否填写电子邮件,
  #       "has_phone" : 是否填写手机号,
  #       "is_email_activated" : 电子邮件是否激活,
  #       "is_phone_activated" : 手机号是否激活,
  #       "connections" : [
  #         {
  #           "site" : connect网站,
  #         },
  #       ],
  #     },
  #     "need_captcha" : 注册时是否需要验证码,
  #   }
  #
  def show
    @account = Core::Account.search_by_params((params[:account]||{}).slice(:login, :email, :phone).merge(:id => params[:id]))
    @account = Core::Account.find_by_id(session[:user_id]) if !params[:account] && session[:user_id] && params[:id].to_i == 0

    respond_to do |format|
      format.xml { @data = {'account' => @account ? @account.assign_options(Core::Account.get_status_xml_options) : nil, 'need_captcha' => @account ? nil : Core::Account.need_captcha?(request.remote_ip)} }
    end
  end

  ##
  # == 验证码是否正确
  #
  # === Request
  #
  # ==== Resource
  #
  # POST /accounts/validate_captcha
  #
  # ==== Parameters
  #
  # captcha :: 验证码 *
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <is_valid>是否有效</is_valid>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #     "is_valid": 是否有效,
  #   }
  #
  def validate_captcha
    is_valid = (params[:captcha] == simple_captcha_value)

    respond_to do |format|
      format.xml { @data = {'is_valid' => !!is_valid} }
    end
  end

  ##
  # == 注册码是否正确
  #
  # === Request
  #
  # ==== Resource
  #
  # POST /accounts/validate_registration
  #
  # ==== Parameters
  #
  # \registration[code] :: 验证码 *
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <is_valid>是否有效</is_valid>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #     "is_valid": 是否有效,
  #   }
  #
  def validate_registration
    is_valid = params[:registration] && params[:registration][:code] && (@registration = Core::Registration.find_by_code(params[:registration][:code])) && @registration.active? && !@registration.account_id

    respond_to do |format|
      format.xml { @data = {'is_valid' => !!is_valid} }
    end
  end

  ##
  # == 获取验证码图片
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /accounts/captcha_image
  #
  # ==== Parameters
  #
  # === Response
  #
  # ==== HTML
  #
  # 重定向到图片地址
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <url>图片地址</url>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #     "url": 图片地址,
  #   }
  #
  def captcha_image
    set_simple_captcha_data(nil)
    url = simple_captcha_url(
        :action => 'simple_captcha',
        :simple_captcha_key => simple_captcha_key,
        :time => Time.now.to_i,
        :font_color => '#CA3F03'
    )

    respond_to do |format|
      format.html { redirect_to url }
      format.xml { @data = {'url' => url} }
    end
  end

  private

  def authorized?
    true
  end
end
