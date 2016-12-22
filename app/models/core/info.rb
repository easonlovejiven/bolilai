##
# = 主站 信息 表
#
# == Fields
#
# country :: 国家
# province :: 省份
# city :: 城市
# im :: MSN
# mobile :: 手机
# phone :: 电话
# website :: 网站
# about :: 关于
# interest :: 兴趣
# music :: 音乐
# movie :: 电影
# tvshow :: 电视
# game :: 游戏
# comic :: 动漫
# sport :: 运动
# book :: 书籍
# point :: 积分
# gene_point :: 基因积分
# auction_point :: 交易积分
# active? :: 有效？
#
# == Indexes
#
class Core::Info < ActiveRecord::Base
  self.table_name = :core_infos

  belongs_to :user, :foreign_key => "id"
  belongs_to :account, :foreign_key => "id"
  belongs_to :hometown, :class_name => 'Data::City'
  belongs_to :location, :class_name => 'Data::City'
  has_many :updatings, :class_name => "Core::InfoUpdating"

  self.xml_options = {
      :only => [:about, :book, :comic, :created_at, :game, :im, :interest, :mobile, :movie, :music, :phone, :sport, :status, :tvshow, :updated_at, :website, :hometown_id, :location_id, :point, :point_updated_at],
      :include => {
          :hometown => {:only => [:country_name, :province_name, :name]},
          :location => {:only => [:country_name, :province_name, :name]}
      }
  }

  def to_attachment # :nodoc: all
    {
        :object_id => '1',
        :object_type => 'test',
        :name => "标题",
        :href => "/profile/#{self.id}",
        :caption => "副标题",
        :description => "描述\n描述\n描述\n",
        :properties => [
            {:name => "test", :text => "images test", :href => "/profile/#{self.id}"},
            {:name => "test", :text => "images test", :href => "/profile/#{self.id}"}
        ],
        :media => [
            {:type => "image", :src => self.pic_n, :href => "/profile/#{self.id}"},
            {:type => "image", :src => self.pic_s, :href => "/profile/#{self.id}"},
            {:type => "image", :src => self.pic_t, :href => "/profile/#{self.id}"},
            {:type => "image", :src => self.pic_q, :href => "/profile/#{self.id}"}
        ],
    }
  end

  def update_point(boundary = 1.hour) # :nodoc: all
    return

    if !self.point_updated_at || (Time.now - self.point_updated_at) > boundary
      resp = begin
        Timeout::timeout(5) { open("http://portal.weimall.com/exchanges.js?type=points&user_id=#{self.id}").read }
      rescue Exception => e
      end

      if resp
        json = ActiveSupport::JSON.decode(resp) rescue {}
        if json['status'] == 'SUCCESS' && json['data'][self.id.to_s]['status'] == 'SUCCESS'
          points = json['data'][self.id.to_s]['data']
          gene_point = points['footprint_points'].to_i
          self.update_attributes(:gene_point => gene_point, :point => gene_point + self.auction_point.to_i, :point_updated_at => Time.now)
        end
      end
    end
    self
  end
end
