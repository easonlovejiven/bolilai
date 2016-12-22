module EditorAttachable
  include ActionView::Helpers::TextHelper

  def self.included(base_class)
    base_class.has_many :uploads, as: :attachmentable
    base_class.before_save do |source|
      if source.body_changed?
        source.pic_url=all_upload_urls[:img].first if source.respond_to?(:pic_url)
        source.summary=get_current_summary if source.respond_to?(:summary)
        source.simplify=get_simplify if source.respond_to?(:simplify)
        source.set_attachment_cache if source.respond_to?(:upload_keys)
      end
    end
    base_class.after_save do |source|
      if source.body_changed?
        set_attachments
      end
    end
    base_class.after_destroy do
      # uploads.update_all({attachmentable_id: nil})
    end
  end

  #获取文章摘要
  def get_current_summary
    doc = Nokogiri::HTML(self.body)
    text = doc.search('//text()[not(preceding-sibling::strong)]').text
    text = text.gsub(/(\s|\u00A0)+/, ' ').strip
    truncate(text, length: 140)
  end

  #一句话摘要
  def get_simplify
    truncate(summary, length: 40)
  end

  def editor_pic_url(style="medium")
    read_attribute(:pic_url) && read_attribute(:pic_url).gsub("content", style.to_s)
  end

  def editor_pic_urls(style="medium")
    upload_keys.blank? ? [] : self.upload_keys.split(",").map { |url| "#{url}-#{style}" }
  end

  def set_attachments
    return false if all_url_keys.blank?
    old_ids = self.uploads.map(&:id)
    now_ids = Upload.where({file_key: all_url_keys}).map(&:id)
    delete_ids = old_ids-(old_ids & now_ids)
    save_ids=now_ids-(old_ids & now_ids)
    Upload.where(id: delete_ids).update_all(attachmentable_id: nil)
    Upload.where(id: save_ids).update_all(attachmentable_id: self.id, attachmentable_type: self.class.base_class)
  end

  def set_attachment_cache
    self.upload_keys = all_upload_urls[:img].map { |url| url.gsub("-content", "") }[0, 4].join(",")
  end

  def all_upload_urls
    urls = {img: [], voice: []}
    doc = Nokogiri::HTML(self.body)
    doc.xpath('//img').each do |i|
      urls[:img] << i['src']
    end
    doc.xpath('//embed').each do |v|
      param_arr = v['src'].to_s.split('&')
      param_arr.each do |p|
        if p.include?('url=')
          urls[:voice] << p.gsub('url=', '')
        end
      end
    end
    urls
  end

  def all_url_keys
    all_upload_urls[:img].collect { |url| url.scan(/uploads\/(.*)-content/).try(:[], 0).try(:[], 0) } +all_upload_urls[:voice].collect { |url| url.scan(/uploads\/(.*)/).try(:[], 0).try(:[], 0) }
  end
end

