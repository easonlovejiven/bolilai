# TODO 已移到users controller，此文件将被删除
#
class Home::InfoController < Home::ApplicationController # :nodoc: all

  # == Function
  #
  # 查看用户信息
  #
  # == Route
  #
  # GET /info/:id
  #
  # == Parameters
  #
  # id :: 用户ID
  #
  # == Response
  #
  # 返回一条Core::User和其资料Core::Info
  #
  #
  # === XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <user><id type="integer">1</id>...</user>
  #     <info><id type="integer">1</id>...</info>
  #   </response>
  #
  # === JSON
  #
  #   {
  #     "user": { "id": 1, ... },
  #     "info": { "id": 1, ... }
  #   }
  #
  def show
    @user = Core::User.find(params[:id])
    @viewer = (params[:viewer_id] && @user == @current_user && Core::User.find_by_id(params[:viewer_id])) || @current_user

    if !@user.allow?(@viewer, 'profile')
      respond_to do |format|
        format.html { redirect_to profile_path(@user) }
        format.xml
      end
      return
    end

    respond_to do |format|
      format.html
      format.xml { @data = {'user' => @user, 'info' => @user.info} }
    end

  end

  def edit
    @user = @viewer = @current_user
    @info = @user.info
    Rails.logger.debug { @info.inspect }
    @colleges = @user.colleges

    @user_colleges_json = @user.college_affiliations.to_json(:only => [:id, :started_at, :ended_at, :position, :profession, :college_id])
    @user_companies_json = @user.network_affiliations.to_json(:only => [:id, :started_at, :ended_at, :position, :profession, :network_id], :include => {:network => {:only => [:id, :name, :type]}})
    respond_to do |format|
      format.xml {
        @data = {
            'user' => @user,
            'viewer' => @viewer,
            'info' => @info,
            'colleges' => @colleges,
            'colleges_json' => @user_colleges_json,
            'companies_json' => @user_companies_json
        }
      }
      format.json {
        @data = {
            'user' => @user,
            'viewer' => @viewer,
            'info' => @info,
            'colleges' => @colleges,
            'colleges_json' => @user_colleges_json,
            'companies_json' => @user_companies_json
        }
      }
    end
  end

  # == Function
  #
  # 更新用户信息
  #
  # == Route
  #
  # PUT /info/:id
  #
  # == Parameters
  #
  # user[name] :: 用户名
  # user[sex] :: 性别
  # user[birthday] :: 生日
  # {"tvshow"=>"", "game"=>"", "interest"=>"", "im"=>"hu_sun@live.cn", "mobile"=>"13466581681", "location_id"=>"417", "phone"=>"", "website"=>"", "music"=>"", "movie"=>"", "comic"=>"", "hometown_id"=>"213", "sport"=>"", "book"=>""}
  # info[tvshow] :: 喜欢节目
  # info[game] :: 喜欢游戏
  # info[interest] :: 兴趣爱好
  # info[im] :: MSN
  # info[mobile] :: 手机
  # info[location_id] :: 所在城市id
  # info[phone] :: 电话
  # info[website] :: 主页
  # info[music] :: 喜欢音乐
  # info[movie] :: 喜欢电影
  # info[comic] :: 喜欢动漫
  # info[hometown_id] :: 家乡id
  # info[sport] :: 喜欢运动
  # info[book] :: 喜欢书
  # college[][position] :: 学校类别
  # college[][id] :: 学校id
  # college[][started_at] :: 上学时间
  # college[][profession] :: 专业
  # work[][position] :: 职位
  # work[][name] :: 公司名称
  # work[][ended_at] :: 工作结束时间
  # work[][started_at] :: 工作起始时间
  # work[][profession] :: 行业
  # == Response
  #
  # 返回修改成功的Core::Info,对应多条Core::College,多条Core::Network
  #
  # === XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <user><id type="integer">1</id>...</user>
  #     <info><id type="integer">1</id>...</info>
  #     <colleges>
  #       <college><id type="integer">1</id>...</college>
  #       <college><id type="integer">1</id>...</college>
  #     </colleges>
  #     <networks>
  #       <network><id type="integer">1</id>...</network>
  #       <network><id type="integer">1</id>...</network>
  #     </networks>
  #
  #   </response>
  #
  # === JSON
  #
  #   {
  #     "user": { "id": 1, ... },
  #     "info": { "id": 2, ... },
  #     "colleges": [
  #        { "id": 1, ... },
  #        { "id": 2, ... },
  #        ...
  #      ]
  #     "networks": [
  #        { "id": 1, ... },
  #        { "id": 2, ... },
  #        ...
  #      ]
  #   }
  #
  def update
    @user = @current_user
    @info = @user.info
    old_name = @user.name
    ActiveRecord::Base.transaction do
      @user.update_attributes(params[:user].merge(:birthday => Time.parse(%Q[#{by = params[:user][:birthday][:year]; by.blank? ? '1970' : by}-#{bm = params[:user][:birthday][:month]; bm.blank? ? '01' : bm}-#{bd = params[:user][:birthday][:day]; bd.blank? ? '01' : bd}])))
      @info.update_attributes(params[:info])
      @info.updated

      params[:college].each_pair do |i, p|
        unless p['id'].to_i.zero?
          college = Core::College.find(p['id'])
          a = Core::Affiliation.find_or_initialize_by_user_id_and_college_id(@user.id, college.id)
          a.position = p['position']
          a.profession = p['profession'] if p['profession'] != '0'
          a.started_at = Time.parse(%Q[#{p['started_at']['year']}-01-01]) if p['started_at'] != "0"
          a.save
        end
      end if params[:college]
      Core::Affiliation.delete_all("user_id=#{@user.id} AND college_id IS NOT NULL#{" AND college_id NOT IN(#{college_ids = params[:college].map { |p| p[1]['id'] }.join(','); college_ids.blank? ? '""' : college_ids})" if !params[:college].empty?}")

      params[:work].each_pair do |i, p|
        unless p['name'].strip.blank?
          network = Core::Network.find_or_create_by_name(p['name'])
          a = Core::Affiliation.find_or_initialize_by_user_id_and_network_id(@user.id, network.id)
          a.profession = p['profession'] if p['profession'] != '0'
          a.position = p['position'] if p['position'] != '0'
          a.started_at = Time.parse(%Q[#{p['started_at']['year']}-#{p['started_at']['month']}-01]) # if p['started_at']
          a.ended_at = Time.parse(%Q[#{p['ended_at']['year']}-#{p['ended_at']['month']}-01]) # if p['ended_at']
          a.save
        end
      end if params[:work]
      Core::Affiliation.delete_all("user_id=#{@user.id} AND network_id IS NOT NULL#{" AND network_id NOT IN(#{params[:work].map { |p| Core::Network.find_or_create_by_name(p[1]['name']).id }.join(',')})"}")
    end

    @user.create_abbr if old_name != @user.name

    respond_to do |format|
      format.html { redirect_to request.referrer || info_path(@info) }
      format.xml { @data = {'user' => @user, 'info' => @info, 'colleges' => @user.colleges, 'networks' => @user.networks} }
    end
  end

  def picture
    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
    end
  end

  # == Function
  #
  # 个人图像
  #
  # == Route
  #
  # POST /info/update_picture
  #
  # == Parameters
  #
  # user[:uploaded_data] :: 照片信息
  #
  # == Response
  #
  # 返回一条Core::User和Photo::User, Core::Album
  #
  # === XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <image>/image/photo/0000/0018/67e667e5526935e1e6437734db297310</image>
  #   </response>
  # === JSON
  #
  #   {
  #     "image": "/image/photo/0000/0018/67e667e5526935e1e6437734db297310"
  #   }
  #
  def update_picture
    @user = @current_user
    @photo_user = Photo::User.find_by_id(@user.id) || (u = Photo::User.new; u.id = @user.id; u.name = @user.name; u)
    @album = @photo_user.head_album

    @photo = Photo::Photo.create(
        :image => params[:user][:uploaded_data],
        :album_id => @album.id,
        :user_id => @user.id
    )

    @user.pic = @photo.image.url
    @user.save

    @photo.feed_id = api(
        :app => Core::App.find(5),
        :method => "stream.publish",
        :attachment => @photo.to_attachment,
        :uid => @photo.user_id
    )
    @photo.save

    respond_to do |format|
      format.html { redirect_to request.referrer || '/' }
      format.xml { @data = {'image' => @user.pic} }
    end
  end

  # == Function
  #
  # 生成缩微图
  #
  # == Route
  #
  # POST /info/update_thumbnail
  #
  # == Parameters
  #
  # x1 :: 顶部距离
  # y1 :: 边距离
  # height :: 高度
  # width :: 宽度
  # == Response
  #
  # 返回空
  #
  # === XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #   </response>
  # === JSON
  #
  #   {
  #   }
  #
  # require 'RMagick' unless defined? Magick
  def update_thumbnail
    @user = @current_user
    path = "#{RAILS_ROOT}/public#{@user.pic}"

    img = Magick::ImageList.new(path)[0]
    img = img.crop(params[:x1].to_i, params[:y1].to_i, params[:height].to_i, params[:width].to_i, true)
    h = img.columns
    w = img.rows
    img.resize(200, 200*w/h).write("#{path}.n.jpg")
    img.resize(100, 100*w/h).write("#{path}.s.jpg")
    img.resize(50, 50*w/h).write("#{path}.t.jpg")
    (h < w ? img.crop(0, 0, h, h) : img.crop((h/2 - w/2), 0, w, w)).strip!.resize(50, 50).write("#{path}.q.jpg")

    respond_to do |format|
      format.html { redirect_to profile_path(@user) }
      format.xml
    end
  end


  # == Function
  #
  #  删除头像
  #
  # == Route
  #
  # GET /info/remove_thumbnail

  # == Response
  #
  # 返回一条Core::User
  #
  # === XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <user><id type="integer">1</id>...</user>
  #   </response>
  # === JSON
  #
  #   {
  #     "user": { "id": 1, ... }
  #   }
  #
  def remove_thumbnail
    @user = @current_user
    @user.pic = nil
    @user.save

    respond_to do |format|
      format.html { redirect_to profile_path(@user) }
      format.xml { @data = {'user' => @user} }
      format.js { render :text => '' }
    end
  end

  # == Function
  #
  #  关于自己
  #
  # == Route
  #
  # GET /info/about_me_andsta_status
  #
  # == Parameters
  #
  # about :: 关于自己
  #
  # == Response
  #
  # 返回一条Core::Info
  #
  # === XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <info><id type="integer">1</id>...</info>
  #   </response>
  # === JSON
  #
  #   {
  #     "info": { "id": 1, ... }
  #   }
  #
  def about_me_and_status # TO BE DELETED 集成到users controller # update
    @info = @current_user.info
    @info.update_attribute("about", params[:about])

    respond_to do |format|
      format.xml { @data = {'info' => @info} }
      format.js { render :text => '' }
    end
  end


  # == Function
  #
  #  返回用户的图像
  #
  # == Route
  #
  # GET /info/get_user_image
  #
  # == Response
  #

  def get_user_image
    respond_to do |format|
      format.js { render :text => @current_user.pic }
      format.xml { @data = {'image' => @current_user.pic} }
    end
  end
end unless Kernel.respond_to? :lm
