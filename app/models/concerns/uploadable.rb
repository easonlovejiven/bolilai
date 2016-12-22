module Uploadable
  def self.included(base_class)
    base_class.send(:attr_accessor, :feilds)
    base_class.has_many :uploads, as: :attachmentable
    base_class.after_create do
      self.set_attachement
      self.update_column(:upload_keys, self.uploads.map { |upload| upload.pic.url }[0, 5].join(","))
    end
  end

  def pic_urls(style="medium")
    self.upload_keys.blank? ? [] : self.upload_keys.split(",").map { |url| "#{url}-#{style}" }
  end

  def pic_url(style="medium")
    self.pic_urls(style).first
  end

  def new_uploads
    ::Upload.where(id: new_upload_ids.to_s.split(","))
  end

  def set_attachement
    new_uploads.update_all(attachmentable_id: self.id, attachmentable_type: self.class.name)
  end
end
