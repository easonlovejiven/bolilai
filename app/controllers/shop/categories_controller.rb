##
# = 商城 分类 界面
#
class Shop::CategoriesController < Shop::ApplicationController
  caches_action :index, :tree, :expires_in => 1.hour.to_i, :cache_path => Proc.new { |controller| controller.request.parameters.dup.merge(:format => controller.request.parameters['_format']).except('_weimall_session', '_format') }

  ##
  # == 列表
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/categories
  #
  # ==== Parameters
  #
  # page :: 页数
  # per_page :: 每页个数
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <categories type="Array">
  #       <category type="Shop::Category">
  #         <id type="integer">ID</id>
  #         <parent_id type="integer">父类ID</parent_id>
  #         <name>名称</name>
  #         <measures>尺寸列表</measures>
  #         <ranges>价格范围</ranges>
  #         <male type="boolean">男士</male>
  #         <female type="boolean">女士</female>
  #         <order type="integer">排序</order>
  #       </category>
  #     </categories>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #     "categories" : [
  #       {
  #         "id" : ID,
  #         "parent_id" : 父类ID,
  #         "name" : 英文名,
  #         "measures" : 尺寸列表,
  #         "ranges" : 价格范围,
  #         "male" : 男士,
  #         "female" : 女士,
  #         "order" : 排序,
  #       },
  #     ]
  #   }
  #
  def index
    @categories = Shop::Category.active.published._where(params[:where])._order(params[:order] || {"`order`" => 'ASC'}).page(params[:page]).per(params[:per_page] || 10)

    respond_to do |format|
      format.html
      format.xml { @data = {'categories' => @categories} }
    end
  end

  ##
  # == 树形列表
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/categories/tree
  #
  # ==== Parameters
  #
  # === Response
  #
  # ==== JSON
  #
  #   {
  #     "category": {
  #       "id": ID,
  #       "name": 名称,
  #       "children": [
  #         "id": ID,
  #         "name": 名称,
  #         "children": [
  #           "id": ID,
  #           "name": 名称,
  #         ]
  #       ]
  #     }
  #   }
  #
  # ==== XML
  #
  # ==== YAML
  #
  def tree
    @category = Shop::Category.find(1)

    def @category.children;
      self.class.active.published.where({:parent_id => self.id}).map { |child|
        def child.children;
          self.class.active.published.where({:parent_id => self.id});
        end

        ; child };
    end

    respond_to do |format|
      format.xml { @data = {'category' => @category.assign_options({:only => [:id, :name, :pic], :objects => {:children => {:only => [:id, :name, :pic], :objects => {:children => {:only => [:id, :name, :pic]}}}}})} }
    end
  end

  ##
  # == 查看
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/categories/:id
  #
  # ==== Parameters
  #
  # id :: ID
  #
  # === Response
  #
  # ==== JSON
  #
  #   {
  #     "category": {
  #       "id" : ID,
  #       "parent_id" : 父类ID,
  #       "name" : 英文名,
  #       "measures" : 尺寸列表,
  #       "ranges" : 价格范围,
  #       "male" : 男士,
  #       "female" : 女士,
  #       "order" : 排序,
  #     }
  #   }
  #
  # ==== XML
  #
  # ==== YAML
  #
  def show
    @category = Shop::Category.acquire(params[:id])

    respond_to do |format|
      format.xml { @data = {'category' => @category} }
    end
  end

  def mall360
    @categories = Shop::Category.active.published._where(params[:where])._order(params[:order] || {"`order`" => 'ASC'})

    respond_to do |format|
      format.html
      format.xml { @data = {'categories' => @categories} }
      format.csv
    end
  end

  private

  def authorized?
    super
    true
  end
end
