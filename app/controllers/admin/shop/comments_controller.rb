class Admin::Shop::CommentsController < Admin::Shop::ApplicationController
  def index
    @comments = Comment.is_active._where(params[:where])._order(params[:order]).page(params[:page]).per(params[:per_page])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @comments }
    end
  end

  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @comment }
    end
  end

  def new
    @comment = Comment.new

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @comment }
    end
  end

  def edit
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @comment }
    end
  end

  def create
    success = database_transaction do
      @commentable = ::Shop::Product.find(comment_params[:commentable_id])
      @comment = Comment.build_from(@commentable, @current_user.id, comment_params)
      @comment.published=true
      imgs = params[:comment][:comment_images_attributes]
      if imgs.present?
        @comment.comment_images_attributes = JSON.parse(imgs).map { |item| item.merge({active: true, user_id: @current_user.id}) }
      end
      @comment.save!
    end

    respond_to do |format|
      if success
        flash[:notice] = '创建成功'
        format.html { redirect_to admin_shop_comments_path }
        format.xml { render :xml => @comment, :status => :created }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end

  end

  def update
    success = database_transaction do
      @comment = Comment.find(params[:id])
      imgs = params[:comment][:comment_images_attributes]
      if imgs.present?
        @comment.comment_images_attributes = JSON.parse(imgs).map { |item| item.merge({active: true, user_id: @current_user.id}) }
      end
      @comment.attributes = comment_params
      @comment.save!
    end

    respond_to do |format|
      if success
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to admin_shop_comments_path }
        format.js { head :ok }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.js { raise }
        format.xml { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def delete
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html { render template: 'admin/shared/delete', locals: {record: @comment, del_url: admin_shop_comment_path(@comment),
                                                                     unable_msg: '有被产品选择而无法删除？'}, :layout => false }
      format.xml { render :xml => @comment }
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    # @comment.destroy
    respond_to do |format|
      format.html { redirect_to admin_shop_comments_url, status: :ok }
      format.xml { head :ok }
    end
  end

  private

  def comment_params
    params[:comment].permit(:id, :user_id, :parent_id, :commentable_id, :title, :ip, :active,
                            :score, :position, :body)
  end
end
