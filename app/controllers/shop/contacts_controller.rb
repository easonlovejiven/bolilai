##
# = 商城 地址 界面
#
class ::Shop::ContactsController < Shop::ApplicationController
  caches_action :options, :expires_in => 1.hour.to_i, :cache_path => Proc.new { |controller| controller.request.parameters.dup.merge(:format => controller.request.parameters['_format']).except('sig', '_weimall_session', '_format') }

  ##
  # == 列表
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/contacts
  #
  # ==== Parameters
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <contacts type="array">
  #       <contact type="::Shop::Contact">
  #         <id type="integer">ID</id>
  #         <user_id type="integer">用户ID</user_id>
  #         <name>姓名</name>
  #         <country>国家</country>
  #         <province>身份</province>
  #         <city>城市</city>
  #         <town>区县</town>
  #         <address>地址</address>
  #         <postcode>邮编</postcode>
  #         <phone>电话</phone>
  #         <mobile>手机</mobile>
  #         <created_at type="datetime">创建时间</created_at>
  #         <updated_at type="datetime">更新时间</updated_at>
  #       </contact>
  #     </contacts>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #     "contacts" : [
  #       {
  #         "id" : ID,
  #         "user_id" : 用户ID,
  #         "name" : 名称,
  #         "country" : 国家,
  #         "province" : 身份,
  #         "city" : 城市,
  #         "town" : 区县,
  #         "address" : 地址,
  #         "postcode" : 邮编,
  #         "phone" : 电话,
  #         "mobile" : 手机,
  #         "created_at" : 创建时间,
  #         "updated_at" : 更新时间,
  #       }
  #     ]
  #   }
  #
  def index
    @contacts = @current_user.contacts.active._order(params[:order] || {:created_at => 'DESC'})

    respond_to do |format|
      format.html
      format.xml { @data = {'contacts' => @contacts} }
    end
  end

  ##
  # == 查看
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/contacts/:id
  #
  # ==== Parameters
  #
  # id :: 联系方式ID
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <contact>
  #       <id type="integer">ID</id>
  #       <user_id type="integer">用户ID</user_id>
  #       <name>姓名</name>
  #       <country>国家</country>
  #       <province>身份</province>
  #       <city>城市</city>
  #       <town>区县</town>
  #       <address>地址</address>
  #       <postcode>邮编</postcode>
  #       <phone>电话</phone>
  #       <mobile>手机</mobile>
  #       <created_at type="datetime">创建时间</created_at>
  #       <updated_at type="datetime">更新时间</updated_at>
  #     </contact>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #     "contact" : {
  #       "id" : ID,
  #       "user_id" : 用户ID,
  #       "name" : 名称,
  #       "country" : 国家,
  #       "province" : 身份,
  #       "city" : 城市,
  #       "town" : 区县,
  #       "address" : 地址,
  #       "postcode" : 邮编,
  #       "phone" : 电话,
  #       "mobile" : 手机,
  #       "created_at" : 创建时间,
  #       "updated_at" : 更新时间,
  #     }
  #   }
  #
  def show
    @contact = ::Shop::Contact.acquire(params[:id])

    if @contact.user_id != @current_user.id
      not_authorized
      return
    end

    respond_to do |format|
      format.html
      format.xml { @data = {'contact' => @contact} }
    end
  end

  ##
  # == 根据request.remote_ip获得位置
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/contacts/new
  #
  # ==== Parameters
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <ip>
  #       <country_name>国家</country_name>
  #       <province_name>省份</province_name>
  #       <city_name>城市</city_name>
  #       <town_name>区县</town_name>
  #     </ip>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #     "ip" : {
  #       "country_name" : 国家,
  #       "province_name" : 省份,
  #       "city_name" : 城市,
  #       "town_name" : 区县,
  #     }
  #   }
  #
  def new
    @ip = Core::Ip.query_by_ip(request.remote_ip)

    respond_to do |format|
      format.html
      format.xml { @data = {'ip' => @ip} }
    end
  end

  def edit # :nodoc: all
    @contact = ::Shop::Contact.acquire(params[:id])

    if @contact.user_id != @current_user.id
      not_authorized
      return
    end

    respond_to do |format|
      format.html { render :layout => false }
      format.js { render :text => '' }
    end
  end

  ##
  # == 创建
  #
  # === Request
  #
  # ==== Resource
  #
  # POST /shop/contacts
  #
  # ==== Parameters
  #
  # \contact[name] :: 姓名
  # \contact[country] :: 国家
  # \contact[province] :: 身份
  # \contact[city] :: 城市
  # \contact[town] :: 区县
  # \contact[address] :: 地址
  # \contact[postcode] :: 邮编
  # \contact[phone] :: 电话
  # \contact[mobile] :: 手机
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <contact>
  #       <id type="integer">ID</id>
  #       <user_id type="integer">用户ID</user_id>
  #       <name>姓名</name>
  #       <country>国家</country>
  #       <province>身份</province>
  #       <city>城市</city>
  #       <town>区县</town>
  #       <address>地址</address>
  #       <postcode>邮编</postcode>
  #       <phone>电话</phone>
  #       <mobile>手机</mobile>
  #       <created_at type="datetime">创建时间</created_at>
  #       <updated_at type="datetime">更新时间</updated_at>
  #     </contact>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #     "contact" : {
  #       "id" : ID,
  #       "user_id" : 用户ID,
  #       "name" : 名称,
  #       "country" : 国家,
  #       "province" : 身份,
  #       "city" : 城市,
  #       "town" : 区县,
  #       "address" : 地址,
  #       "postcode" : 邮编,
  #       "phone" : 电话,
  #       "mobile" : 手机,
  #       "created_at" : 创建时间,
  #       "updated_at" : 更新时间,
  #     }
  #   }
  #
  def create
    @contact = ::Shop::Contact.new(contact_params)

    if @contact.save
      render json: {success: true, msg: '添加地址成功', data: @contact,contact: @contact},status: :ok
    else
      render json: {success: false, msg: '添加地址失败', data: @contact},status: :unprocessable_entity
    end
  end

  ##
  # == 更新
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /auction/contacts/:id
  #
  # ==== Parameters
  #
  # id :: 联系方式ID
  # \contact[name] :: 姓名
  # \contact[country] :: 国家
  # \contact[province] :: 身份
  # \contact[city] :: 城市
  # \contact[town] :: 区县
  # \contact[address] :: 地址
  # \contact[postcode] :: 邮编
  # \contact[phone] :: 电话
  # \contact[mobile] :: 手机
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <contact>
  #       <id type="integer">ID</id>
  #       <user_id type="integer">用户ID</user_id>
  #       <name>姓名</name>
  #       <country>国家</country>
  #       <province>身份</province>
  #       <city>城市</city>
  #       <town>区县</town>
  #       <address>地址</address>
  #       <postcode>邮编</postcode>
  #       <phone>电话</phone>
  #       <mobile>手机</mobile>
  #       <created_at type="datetime">创建时间</created_at>
  #       <updated_at type="datetime">更新时间</updated_at>
  #     </contact>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #     "contact" : {
  #       "id" : ID,
  #       "user_id" : 用户ID,
  #       "name" : 名称,
  #       "country" : 国家,
  #       "province" : 身份,
  #       "city" : 城市,
  #       "town" : 区县,
  #       "address" : 地址,
  #       "postcode" : 邮编,
  #       "phone" : 电话,
  #       "mobile" : 手机,
  #       "created_at" : 创建时间,
  #       "updated_at" : 更新时间,
  #     }
  #   }
  #
  def update
    @contact = ::Shop::Contact.acquire(params[:id])

    if @contact.user_id != @current_user.id
      not_authorized
      return
    end

    if  @contact.update_attributes(contact_params)
      render json: {success: true, msg: '添加地址成功', data: @contact}
    else
      render json: {success: false, msg: '添加地址失败', data: @contact}
    end
  end

  ##
  # == 删除
  #
  # === Request
  #
  # ==== Resource
  #
  # DELETE /auction/contacts/:id
  #
  # ==== Parameters
  #
  # id :: 联系方式ID
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
  def destroy
    @contact = ::Shop::Contact.acquire(params[:id])

    if @contact.user_id != @current_user.id
      not_authorized
      return
    end

    @contact.destroy_softly

    respond_to do |format|
      format.html
      format.xml
    end
  end

  ##
  # == 国家、身份、城市、区县选项
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/contacts/options
  #
  # ==== Parameters
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
  def options
    respond_to do |format|
      format.html
      format.xml { @data = {'countries' => Data::Country.active.published.map { |c| {'id' => c.id, 'name' => c.name, 'order' => c.order, 'provinces' => c.provinces.active.published.map { |p| {'id' => p.id, 'name' => p.name, 'order' => p.order, 'cities' => p.cities.active.published.map { |ci| {'id' => ci.id, 'name' => ci.name, 'order' => ci.order, 'towns' => ci.towns.active.published.map { |t| {'id' => t.id, 'name' => t.name, 'order' => t.order} }} }} }} }} }
      format.js { render :text => {:provinces => Data::Country.find(1).provinces.active.published.order('`order` ASC').map { |province| {:name => province.name, :cities => province.cities.active.published.order('`order` ASC').map { |city| {:name => city.name, :towns => city.towns.active.published.order('`order` ASC').map { |town| {:name => town.name} }} }} }}.to_json }
    end
  end

  ##
  # == 选择支付宝地址页面
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/contacts/alipay
  #
  # ==== Parameters
  #
  # redirect :: 跳转地址
  #
  # === Response
  #
  # ==== HTML
  #
  # 重定向到付款页面
  #
  # ==== XML
  #
  #   <response>
  #     <url>地址</url>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #     "url" : 地址,
  #   }
  #
  def alipay
    url = Shop::Trade.new.alipay_address_url(:user => @current_user, :redirect => params[:redirect])

    respond_to do |format|
      format.html { redirect_to url }
      format.xml { @data = {'url' => url} }
    end
  end

  def alipay_return
    # debugger
  end

  private
  def contact_params
    params[:contact].permit(:name, :country, :province, :city, :town, :address, :postcode, :phone, :mobile)
        .merge(:user_id => @current_user.id)
  end
end
