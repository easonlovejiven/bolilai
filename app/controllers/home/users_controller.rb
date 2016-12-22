##
# = 主站 用户 界面
#
class Home::UsersController < Home::ApplicationController
  caches_action :city_list, :college_list, :edit,
                :if => Proc.new { |controller| ['xml', 'json'].include?(controller.request.parameters['_format']) },
                :cache_path => Proc.new { |controller| "#{controller.controller_name}/#{controller.request.parameters['action']}.#{controller.request.parameters['_format']}" }
  # :cache_path => Proc.new { |controller| controller.request.parameters.dup.merge(:format => controller.request.parameters['_format']).except('sig','_weimall_session','_format','id','auth_token')}

  ##
  # == 搜索用户
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /users
  #
  # ==== Parameters
  #
  # page :: 页数
  # per_page :: 每页个数
  # \where[name] :: 姓名，必须的 *
  #
  # 以下参数根据最新需求已不支持
  # \where[sex] :: 性别，male或female或不传
  # \where[birthday][gteq] :: 开始年龄段，比如1990/1/1。两个age参数需一起传，比如小于15岁，gteq则为0岁时的时间
  # \where[birthday][lteq] :: 结束年龄段，比如1998/12/31 23:59:59
  # \where[city][] :: 城市ID
  #
  # === Response
  #
  # ==== JSON
  #
  #   {
  #     "users" : [
  #       {
  #         "id" : ID,
  #         "pic" : 头像,
  #         "name" : 名字,
  #         "sex" : 性别,
  #         "birthday" : 生日,
  #       }
  #     ]
  #   }
  #
  def index
    params[:per_page] ||= 10
    params[:page] ||= 1
    where = params[:where]

    users = if IS_SPHINX_ENABLED
              # 可以连续，但非顺序相同 地匹配
              with = {:search_engine_indexing => true}
              if where[:birthday]
                gteq, lteq = Time.parse(where[:birthday][:gteq]), Time.parse(where[:birthday][:lteq])
                with.merge!(:birthday_attr => gteq..lteq)
              end
              with.merge!(:sex_attr => where[:sex].to_crc32) if where[:sex]
              if where[:city]
                where[:city] = where[:city].values if where[:city].is_a? Hash
                with.merge!(:location_id_attr => where[:city])
              end
              with.merge!(:sphinx_deleted => 0)
              Core::Account.search(where[:name], :with => with, :match_mode => :phrase, :rank_mode => :proximity_bm25, :order => "@relevance DESC created_at DESC").paginate(params).map(&:user)
            else
              return if (@name = where[:name].to_s.strip.downcase).blank?
              @reg = Regexp.new(@name)

              citizens = begin
                where[:city] = where[:city].values if where[:city].is_a? Hash # 兼容数组下标
                where[:city].blank? ? nil : Core::Info.scoped(:conditions => "location_id IN (#{where[:city].join(',')})").map(&:user).compact # compact 仅为兼容有core_infos记录但是没有core_users记录的用户
              end

              if citizens
                citizens = citizens.select { |x| x.sex == where[:sex] } unless where[:sex].blank?
                citizens = citizens.select { |x| b = x.birthday.to_time; (b >= Time.parse(where[:birthday][:gteq])) && (b <= Time.parse(where[:birthday][:lteq])) } if where[:birthday].is_a?(Hash)

                ra = citizens.select { |x| x.name =~ @reg }
                rb = citizens.select { |x| bps.detect { |bp| bp.call(x) } }
                citizens = (ra + rb).sort { |x, y| x.id <=> y.id }.uniq
                citizens = citizens.select { |x| allow_search x }

                b = 0 + 10 * (params[:page].to_i - 1)
                e = b + params[:per_page].to_i - 1
                citizens[b..e]
              else
                [:name, :id].each { |x| params[:where].delete x }
                find_in_batches Core::User, {:boolean_procs => (bps << proc { |item| item.name.to_s.match(@reg) }), :fix_user_search => true}
              end || []
            end

    respond_to do |format|
      format.xml {
        @data = {'users' => users.assign_options({:only => [:id, :pic, :name, :sex, :birthday]})}
      }
    end
  end

  ##
  # == 查看
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /users/:id
  #
  # ==== Parameters
  #
  # id :: 用户ID
  #
  # === Response
  #
  #
  # ==== JSON
  #
  #   {
  #     "user" : {
  #       "id" : ID,
  #       "pic" : 头像,
  #       "name" : 名字,
  #       "sex" : 性别,
  #       "birthday" : 生日,
  #       "info" : {
  #         "created_at" : 创建时间,
  #         "hometown" : {
  #           "country_name" : 国家,
  #           "province_name" : 省份,
  #           "name" : 城市,
  #         },
  #         "location" : {
  #           "country_name" : 国家,
  #           "province_name" : 省份,
  #           "name" : 城市,
  #         },
  #         "point" : 积分,
  #       },
  #       "setting" : {
  #         "receive_promotion_email" : 接受悦购推广邮件,
  #       },
  #       account: {
  #         "email": 邮件,
  #         "phone": 手机,
  #         "created_at": 创建时间,
  #         "last_login_at": 最近登录日期,
  #         "link": {
  #           "ad": {
  #             "promotion": {
  #                "name": 名称,
  #             }
  #           }
  #         }
  #       },
  #       "auction_user": {
  #         "trades_price_sum": 交易总额,
  #         "trades_point": 交易积分,
  #         "percent": 折扣,
  #         "balance": 余额,
  #         "cards_balance": 礼品卡总余额,
  #         "has_password": 有无密码,
  #         "texas_holdem_code": 德州扑克活动码,
  #         "malls": [
  #           {
  #             "id": ID,
  #             "pic": 图片,
  #             "rule" : 规则图片,
  #             "detail" : 详情图片,
  #             "genre" : 类别，可以为{ 'vip' => 'VIP', 'sale' => '特卖' } 之一,
  #             "name": 名称,
  #             "description": 描述,
  #             "percent": 最大折扣,
  #           },
  #         ],
  #         "level": {
  #           "id": 等级ID,
  #           "icon": 图标,
  #           "name": 名称,
  #           "description": 描述,
  #           "limitation": 限制,
  #           "reservation": 保留,
  #           "percent": 最大折扣,
  #           "malls": [
  #             {
  #               "id": 商城ID,
  #               "pic": 图片,
  #               "rule" : 规则图片,
  #               "detail" : 详情图片,
  #               "genre" : 类别，可以为{ 'vip' => 'VIP', 'sale' => '特卖' } 之一,
  #               "name": 名称,
  #               "description": 描述,
  #               "percent": 最大折扣,
  #             },
  #           ],
  #         },
  #       },
  #     },
  #   }
  #
  def show
    params[:id] = @current_user.try(:id) if params[:id] == 'account'
    @user = Core::User.includes(:info).acquire(params[:id])
    @trades = @user.trades.active._where(params[:where])._order(params[:order]).limit(6)
    xo = Core::User.xml_options.deep_clone
    xo[:include].delete :affiliations
    xo[:include][:info][:only] -= [:about, :book, :comic, :game, :hometown_id, :im, :interest, :location_id, :mobile, :movie, :music, :phone, :point_updated_at, :sport, :status, :tvshow, :website]
    # xo[:include][:setting][:only] -= [:adds_a_friend_i_suggested, :adds_me_as_a_friend, :basic, :confirms_a_friendship_request, :comments_after_me_on_a_wall_story, :comments_on_a_story_in_my_wall, :confirms_a_friendship_reauest, :friend, :i_invited_joins_facebook, :im, :note, :photo, :pokes_me, :posts_on_my_wall, :profile, :public_online_status, :search_engine_indexing, :sends_me_a_message, :share, :suggests_a_friend_to_me]

    if @user.id == @current_user.id
      xo[:include][:account] = {
        :only => [:email, :phone, :created_at, :last_login_on],
        :include => {
          :link => {
            :only => [],
            :include => {
              :ad => {
                :only => [],
                :include => {
                  :promotion => {:only => [:name]}
                }
              }
            }
          }
        }
      }

      xo[:include][:shop_user] = {
        :only => [:trades_price_sum, :trades_point, :percent, :balance, :texas_holdem_code],
        :methods => [:has_password, :cards_balance],
        :objects => {
          :malls => {
            :only => [:id, :pic, :rule, :detail, :genre, :name, :description, :percent,],
          },
          :level => {
            :only => [:id, :icon, :name, :description, :limitation, :reservation, :percent,],
            :objects => {
              :malls => {
                :only => [:id, :pic, :rule, :detail, :genre, :name, :description, :percent,],
              },
            },
          },
        },
      }
    else
      xo = {
        :only => [:id, :pic, :name, :sex],
        :include => {
          :info => {:only => [:created_at, :updated_at, :point]},
          :setting => xo[:include][:setting]
        }
      }
    end
    respond_to do |format|
      format.html #{ redirect_to profile_path(@user) unless allow }
      format.xml { @data = {'user' => @user.assign_options(xo), 'trades_count' => Shop::User.acquire(@user.id).trades.count} }
    end
  end

  ##
  # == 查看用户积分
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /users/:id/point
  #
  # ==== Parameters
  #
  # id :: 用户ID
  #
  # === Response
  #
  # ==== JSON
  #
  #   {
  #     "user" : {
  #       "info" : {
  #         "point" : 积分,
  #       }
  #     }
  #   }
  #

  def point
    @user = Core::User.acquire(params[:id])
    @info = @user.info
    @info.update_point

    respond_to do |format|
      format.xml { @data = {'user' => {'info' => {'point' => @info.point}}} }
    end
  end

  ##
  # == 编辑用户信息
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /users/:id/edit
  #
  # GET /users/city_list
  #
  # GET /users/college_list
  #
  # ==== Parameters
  #
  # id :: 用户ID
  #
  # === Response
  #
  # ==== JSON
  #
  #   {
  #     "college_list": {
  #       "countries": [
  #         {
  #           "name": 国家名称,
  #           "provinces": [
  #             {
  #               "name": 省份名称,
  #               "colleges": [
  #                 {
  #                   "id": 大学ID,
  #                   "name": 大学名称,
  #                   "pinyin": 大学名称拼音,
  #                 },
  #               ],
  #             },
  #           ],
  #         },
  #       ],
  #     },
  #     "city_list": {
  #       "countries": [
  #         {
  #           "name": 国家名称,
  #           "provinces": [
  #             {
  #               "name": 省份名称,
  #               "cities": [
  #                 {
  #                   "id": 城市ID,
  #                   "name": 城市名称,
  #                   "pinyin": 城市名称拼音,
  #                 },
  #               ],
  #             },
  #           ],
  #         },
  #       ],
  #     },
  #   }
  #
  def edit
    @user = @viewer = @current_user
    @info = @user.info
    #@data = { 'city_list' => { 'countries' => Core::City.active.group_by(&:country_name).
    # map{|g1| { 'name' => g1[0], 'provinces' => g1[1].group_by(&:province_name).map{|g2| { 'name' => g2[0], 'cities' => g2[1].map{|c| { :id => c.id, :name => c.name, :pinyin => Pinyin.t(c.name).split.join } } } } } } },
    # 'college_list' => { 'countries' => Core::College.active.group_by(&:country_name).map{|g1| { 'name' => g1[0], 'provinces' => g1[1].group_by(&:province_name).map{|g2| { 'name' => g2[0], 'colleges' => g2[1].
    # map{|c| { :id => c.id, :name => c.name, :pinyin => Pinyin.t(c.name).split.join } } } } } } } }
    respond_to do |format|
      format.html
      format.xml {}
    end
  end

  def city_list
    respond_to do |format|
      format.xml { @data = {'city_list' => {'countries' => Core::City.active.group_by(&:country_name).map { |g1| {'name' => g1[0], 'provinces' => g1[1].group_by(&:province_name).map { |g2| {'name' => g2[0], 'cities' => g2[1].map { |c| {:id => c.id, :name => c.name, :pinyin => Pinyin.t(c.name).split.join} }} }} }}} }
    end
  end

  # TODO 需把"广"对应的"yan"改为"guang", 还有#edit
  def college_list
    respond_to do |format|
      format.xml { @data = {'college_list' => {'countries' => Core::College.active.group_by(&:country_name).map { |g1| {'name' => g1[0], 'provinces' => g1[1].group_by(&:province_name).map { |g2| {'name' => g2[0], 'colleges' => g2[1].map { |c| {:id => c.id, :name => c.name, :pinyin => Pinyin.t(c.name).split.join} }} }} }}} }
    end
  end

  ##
  # == 更新用户信息
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /users/:id
  #
  # POST /users/:id/update
  #
  # ==== Parameters
  #
  # id :: 用户ID
  #
  # \user[pic] :: nil为删除头像，图片文件则为更新头像
  # \user[avatar] :: Base64编码的圆形头像
  # \user[name] :: 用户名
  # \user[sex] :: 性别
  # \user[birthday] :: 生日
  # \info[tvshow] :: 喜欢节目
  # \info[game] :: 喜欢游戏
  # \info[interest] :: 兴趣爱好
  # \info[im] :: MSN
  # \info[mobile] :: 手机
  # \info[location_id] :: 所在城市id
  # \info[phone] :: 电话
  # \info[website] :: 主页
  # \info[music] :: 喜欢音乐
  # \info[movie] :: 喜欢电影
  # \info[comic] :: 喜欢动漫
  # \info[hometown_id] :: 家乡id
  # \info[sport] :: 喜欢运动
  # \info[book] :: 喜欢书
  # \info[registration_completed] :: 是否完成了注册引导（布尔值）
  # \setting[profile] :: 个人主页隐私
  # \setting[friend] :: 好友隐私
  # \setting[basic] :: 基本信息隐私
  # \setting[im] :: 联系方式隐私
  # \setting[note] :: 日志隐私
  # \setting[photo] :: 相册隐私
  # \setting[share] :: 分享隐私
  # \setting[search_engine_indexing] :: 搜索引擎
  # \setting[sends_me_a_message] :: 发送信息给我
  # \setting[adds_me_as_a_friend] :: 加我好友
  # \setting[confirms_a_friendship_request] :: 确认好友请求
  # \setting[suggests_a_friend_to_me] :: 建议好友
  # \setting[adds_a_friend_i_suggested] :: 加我建议的好友
  # \setting[i_invited_joins_facebook] :: 邀请的人注册
  # \setting[pokes_me] :: 打招呼
  # \setting[posts_on_my_wall] :: 在我的主页留言
  # \setting[comments_on_a_story_in_my_wall] :: 评论我的新鲜事
  # \setting[comments_after_me_on_a_wall_story] :: 评论我出现过的新鲜事
  # \setting[public_online_status] :: 显示在线状态
  # \setting[receive_promotion_email] :: 接受悦购推广邮件
  # 删除已有照片则需明确设affiliations为nil, 更新照片（包括删除已有和添加）则传要添加的affiliations[][参数]和想要保留的affiliations[][id]
  #
  # === Response
  # ==== JSON
  #
  #   {
  #     "user" : {
  #       "id" : ID,
  #       "pic" : 头像,
  #       "name" : 名字,
  #       "sex" : 性别,
  #       "birthday" : 生日,
  #       "info" : {
  #         "im" : MSN,
  #         "mobile" : 手机,
  #         "phone" : 电话,
  #         "website" : 网站,
  #         "about" : 关于,
  #         "interest" : 兴趣,
  #         "music" : 音乐,
  #         "movie" : 电影,
  #         "tvshow" : 电视,
  #         "game" : 游戏,
  #         "comic" : 动漫,
  #         "sport" : 运动,
  #         "book" : 书籍,
  #         "created_at" : 创建时间,
  #         "updated_at" : 更新时间,
  #         "status" : 状态,
  #         "hometown_id" : 故乡id,
  #         "hometown" : {
  #           "country_name" : 国家,
  #           "province_name" : 省份,
  #           "name" : 城市,
  #         },
  #         "location" : 城市ID,
  #         "location" : {
  #           "country_name" : 国家,
  #           "province_name" : 省份,
  #           "name" : 城市,
  #         },
  #         "point" : 积分,
  #       },
  #       "setting" : {
  #         "profile" : 个人主页隐私,
  #         "friend" : 好友隐私,
  #         "basic" : 基本信息隐私,
  #         "im" : 联系方式隐私,
  #         "note" : 日志隐私,
  #         "photo" : 相册隐私,
  #         "share" : 分享隐私,
  #         "search_engine_indexing" : 搜索,
  #         "sends_me_a_message" : 给我发消息,
  #         "adds_me_as_a_friend" : 好友申请,
  #         "confirms_a_friendship_request" : 别人通过了我的好友请求,
  #         "suggests_a_friend_to_me" : 好友给我介绍朋友,
  #         "adds_a_friend_i_suggested" : 好友把我推荐的人添加为其好友,
  #         "i_invited_joins_facebook" : 被我邀请加入了weimall,
  #         "pokes_me" : 打招呼请求,
  #         "posts_on_my_wall" : 在我的主页留言,
  #         "comments_on_a_story_in_my_wall" : 对我进行评论,
  #         "comments_after_me_on_a_wall_story" : 我评论过的内容有新的评论,
  #         "public_online_status" : 显示在线状态,
  #         "receive_promotion_email" : 接受悦购推广邮件,
  #       },
  #       affiliations: [
  #         {
  #           "id": ID,
  #           "started_at": 开始日期,
  #           "ended_at": 结束日期,
  #           "position": 职位,
  #           "profession": 专业,
  #           "college_id": 学校ID,
  #           "network_id": 公司ID,
  #           "college": {
  #             "id": ID,
  #             "name": 名称,
  #           },
  #           "network": {
  #             "id": ID,
  #             "name": 名称,
  #           },
  #         }
  #       ],
  #     },
  #   }
  #
  def update
    update_params=params.permit(:authenticity_token, :commit, :year, :month, :day, :id, :utf8, :user => [:authenticity_token, :pic, :name, :sex, :commit], :info => [:hometown_id,:location_id])
    @user = @current_user
    @info = @user.info
    if params[:user] && params[:user][:pic]
      # @album = Photo::User.acquire(@user.id).head_album
      # @photo = @album.photos.create(:image => params[:user][:pic], :user_id => @user.id)
      # Paperclip.generate_image_meta_info(@photo, params[:user][:pic], 'pic')
      # @album.generate_thumbnails

      # @feed = Core::Feed.publish(
      #     :app => Core::App.find(5),
      #     :actor => @user,
      #     :content => "上传了新头像",
      #     :attachment => @photo.to_attachment
      # )
      #
      # @photo.feed_id = @feed.id
      # @photo.save

      # @user.photo_id = @photo.id
      @user.pic = params[:user][:pic]
      @user.save
    end

    success = true
    ActiveRecord::Base.transaction do
      success &&=if params[:info]
                   @hometown=Data::City.where(name: params[:info][:hometown_id]).first_or_initialize
                   @location=Data::City.where(name: params[:info][:location_id]).first_or_initialize
                   update_params[:info].merge!(hometown_id: @hometown.id,location_id: @location.id)
                   @user.info.update_attributes(update_params[:info])
                 end
      success &&= @user.setting.update_attributes(update_params[:setting]) if params[:user][:setting]

      if params[:user]
        update_params[:user][:birthday] = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i).to_s
        update_params[:user][:pic] = nil if (pic = params[:user].delete(:pic)) && (pic == 'nil' || pic == '')
        if update_params[:user][:name]
          update_params[:user][:abbrs] = @user.name_abbr(params[:user][:name])
          @user.account.touch
        end

        success &&= @user.update_attributes(update_params[:user])
      end

    end

    if success
      @user.updated if params[:user]
      @user.info.updated if params[:info]
      @user.setting.updated if params[:setting]
      @user.account.updated if params[:account]

      respond_to do |format|
        format.html { redirect_to request.referrer || users_path(@user) }
        format.js { render :text => '' }
        format.xml { @data = {'user' => (xo = Core::User.xml_options.deep_clone; xo[:only] << :birthday; @user.assign_options(xo))} }
      end
    else
      respond_to do |format|
        format.html { render :action => 'edit' }
        format.js { head 500 }
        format.xml { raise ActiveRecord::RecordInvalid.new(@user) }
      end
    end
  end

  def destroy # :nodoc:
  end

  def picture # :nodoc:
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  private
  def real_path(url) # :nodoc:
    "#{RAILS_ROOT}/public#{url}"
  end

  def bps
    @bps ||= begin
      @az = ('a'..'z').to_a
      bps = []
      bps << proc { |item| item.abbrs.to_s.split(',').index(@name) } if @name.chars.to_a.detect { |x| @az.index x }
      bps
    end
  end

  def allow
    @user==@current_user
  end

  def allow_search(item)
    item.setting.search_engine_indexing
  end
end
