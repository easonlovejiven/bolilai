class Admin::UploadsController < Admin::ApplicationController
  layout false

  def index
    @images = Upload.images._where(params[:where]).order('id desc').page(params[:page]).per(params[:per_page])
  end

  def create
    @upload = Upload.new(upload_params) do |upload|
      upload.user = @current_user
    end
    if @upload.save
      render json: @upload, status: :created, location: @upload
    else
      render json: @upload.errors, status: :unprocessable_entity
    end
  end

  def delete
    @upload = Upload.acquire(params[:id])

    respond_to do |format|
      format.html { render template: 'admin/shared/delete', locals: {record: @upload, unable_msg: '该图片无法删除？'}, :layout => false }
    end
  end

  def batch_delete
    @uploads = Upload.where(id: params[:ids].split(","))
    respond_to do |format|
      format.html { render template: 'admin/shared/batch_delete', locals: {records: @uploads, del_url: admin_uploads_path(:id => @uploads.map(&:id).join(",")), unable_msg: '该图片无法删除？'}, :layout => false }
    end
  end

  def destroy
    @uploads = Upload.where(id: params[:id].split(","))
    @uploads.each(&:destroy)

    respond_to do |format|
      format.html { redirect_to :action => 'index', status: :ok }
    end
  end

  private

  def upload_params
    params[:upload].permit(:file_key, :attachmentable_type, :attachmentable_id, :file_name, :file_type, :file_size)
  end

end
