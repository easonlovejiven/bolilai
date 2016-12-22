class Home::CommentsController < Home::ApplicationController

  def index
    @trades = @current_user.trades.select(:id).active.where(:status => 'complete')
    @units = ::Shop::Unit.where(trade_id: @trades.map(&:id)).order('id DESC').page(params[:page]).per(params[:per_page] || 10)
    respond_to do |format|
      format.html
    end
  end

  def create
    success = database_transaction do
      @user = Core::User.find(params[:user_id])
      @commentable = find_commentable
      @comment = Comment.new(comment_params.merge(user_id: @current_user.id, editor_id: @current_user.id))
      @comment.commentable = @commentable
      imgs = params[:comment][:comment_images_attributes]
      if imgs.present?
        @comment.comment_images_attributes = JSON.parse(imgs).map { |item| item.merge({active: true, user_id: @current_user.id}) }
      end
      @comment.save!
      Shop::Unit.where(id: params[:unit_id]).update_all(comment_added: true)
    end
    if success
      render json: {success: true, msg: '评价成功'}
    else
      render json: {success: false, msg: '评价成功'}
    end
  end

  private

  def find_commentable
    @commentable = params[:commentable_type].to_s.constantize.find(params[:commentable_id])
  end

  def comment_params
    params[:comment].permit(:user_id, :parent_id, :title, :ip, :score, :body)
  end
end
