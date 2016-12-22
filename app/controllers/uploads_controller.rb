class UploadsController < ApplicationController
  # before_action :authenticate_user!,:authenticate_admin!

  def file_keys
    uploads = Upload.where(file_type: ['image/jpeg', 'image/png', "image/jpeg", "image/gif", "image/bmp"])
    @uploads = uploads.offset(params[:start]||0).limit(params[:size]||10).order('id desc')
    render json: {state: 'SUCCESS', list: @uploads, start: params[:start]||0, total: uploads.count}
  end

  def callback
    action = params['action']
    if action == "callback"
      upload = Upload.new
      upload.user = session[:user] if session[:user]
      upload.file_key = params["file_key"]
      upload.file_name = params["file_name"]
      upload.file_size = params["file_size"]
      upload.file_type = params["file_type"]

      upload.save
    end
    render :text => params.to_s
  end

  def uptoken
    #opts={:scope=>Gaibian::Application::QINIU_BUCKET,:callback_body=>"name=$(fname)&hash=$(etag)&location=$(x:location)&=$(x:prise)",:callback_url=>"xxxx"}
    opts={:scope => Rails.application.secrets[:qiniu_weimall]}
    token=Qiniu.generate_upload_token(opts)
    render :json => {uptoken: token}
  end

  def avatar_uptoken
    #opts={:scope=>Gaibian::Application::QINIU_BUCKET,:callback_body=>"name=$(fname)&hash=$(etag)&location=$(x:location)&=$(x:prise)",:callback_url=>"xxxx"}
    opts={:scope => Rails.application.secrets[:qiniu_avatar]}
    token=Qiniu.generate_upload_token(opts)
    render :json => {uptoken: token}
  end

  def download
    @upload = Upload.find(params[:id])
    if @upload.file_key
      info = Qiniu.get(QiniuRailsExample::Application::QINIU_BUCKET, @upload.file_key, @upload.file_name)
      if info
        redirect_to info["url"]
      end
    end
  end

  def create
    @upload = Upload.new(params[:upload].permit(:file_key, :attachmentable_type, :attachmentable_id, :file_name, :file_type, :file_size)) do |upload|
      upload.user = @current_user
    end
    if @upload.save
      render json: @upload, status: :created, location: @upload
    else
      render json: @upload.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy
    render :json => @upload.to_json
  end

end
