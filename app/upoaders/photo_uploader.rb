# encoding: utf-8
class PhotoUploader < CarrierWave::Uploader::Base
  #include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  #storage :file
  storage :qiniu

  def initialize(*)
    super
    self.class.qiniu_bucket=Rails.application.secrets[:qiniu_weimall]
    self.class.qiniu_bucket_domain=Rails.application.secrets[:qiniu_weimall_domain]
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    ActionController::Base.helpers.image_url('/themes/cover/default.jpg')
  end

  # 文章图片
  version :content, :if => :has_version? do
    process :resize_to_fill => [1178, nil]

    def full_filename (for_file = model.logo.file)
      "#{for_file}-content"
    end
  end

 # 微信封面
  version :cover, :if => :has_version? do
    process :resize_to_fill => [640, nil]

    def full_filename (for_file = model.logo.file)
      "#{for_file}-cover"
    end
  end

  # 微信封面
  version :cover320, :if => :has_version? do
    process :resize_to_fill => [320, nil]

    def full_filename (for_file = model.logo.file)
      "#{for_file}-cover320"
    end
  end

  # Create different versions of your uploaded files:
  version :big, :if => :has_version? do
    process :resize_to_fill => [800, nil]

    def full_filename (for_file = model.logo.file)
      "#{for_file}-big"
    end
  end

  version :big800, :if => :has_version? do
    process :resize_to_fill => [800, 800]

    def full_filename (for_file = model.logo.file)
      "#{for_file}-big800"
    end
  end

  version :cover400, :if => :has_version? do
    process :resize_to_fill => [400, 400]

    def full_filename (for_file = model.logo.file)
      "#{for_file}-cover400"
    end
  end

  version :cover280, :if => :has_version? do
    process :resize_to_fill => [280, 140]

    def full_filename (for_file = model.logo.file)
      "#{for_file}-cover280"
    end
  end

  version :medium, :if => :has_version? do
    process :resize_to_fit => [200, 200]

    def full_filename (for_file = model.logo.file)
      "#{for_file}-medium"
    end
  end

  version :thumb220, :if => :has_version? do
    process :resize_to_fit => [220, 220]

    def full_filename (for_file = model.logo.file)
      "#{for_file}-thumb220"
    end
  end

  version :thumb, :if => :has_version? do
    process :resize_to_fit => [100, 100]

    def full_filename (for_file = model.logo.file)
      "#{for_file}-thumb"
    end
  end

  version :tiny, :if => :has_version? do
    process :resize_to_fit => [50, 50]

    def full_filename (for_file = model.logo.file)
      "#{for_file}-tiny"
    end
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    if original_filename.present?
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.jpg"
    end
  end

  def has_version?(new_file)
    !storage.is_a?(CarrierWave::Storage::Qiniu)
  end

end
