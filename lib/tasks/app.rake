namespace :shop do
  desc 'sync_synonym'
  task :sync_synonym => :environment do
    Shop::Brand.active.published.each do |brand|
      [brand.name, brand.chinese, brand.abbreviation].each do |name|
        Shop::Synonym.create!(:name => name.to_s.strip, :brand_id => brand.id, published: true) if !name.to_s.strip.blank? && !Shop::Synonym.active.find_by_name(name)
      end
    end
    Shop::Category.active.published.where("id != 1").each do |category|
      next if (name = category.name.to_s.strip).blank? || Shop::Synonym.active.find_by_name(name)
      next unless options = category.parent_id == 1 && {:category1_id => category.id} || category.parent && category.parent.parent_id == 1 && {:category2_id => category.id}
      Shop::Synonym.create!(options.merge(:name => name, published: true))
    end
  end

  desc "fix article"
  task :fix_article_images => :environment do
    Cms::Page.all.each do |page|
      doc = Nokogiri::HTML(page.body)
      doc.css('img').each do |i|
        i["src"]=i["src"].gsub("-big", "-content")
      end
      page.update_column "body", doc.css("body").inner_html
    end
    Cms::Page.all.each do |page|
       page.update_column "pic_url",page.pic_url.gsub("-big", "-content") if !page.pic_url.blank?
    end
  end

  desc "fix demo image path"
  task :fix_demo_images=>:environment do
    args=["http://7xntkw.com2.z0.glb.qiniucdn.com","http://7xpbqw.com1.z0.glb.clouddn.com"]
    CustomPage::Page.all.each do |page|
      content=page.content.gsub(*args)
      page.content=content
      page.save
    end
    Cms::Page.all.each do |page|
      content=page.body.gsub(*args)
      page.body=content
      page.save
    end
    Cms::Category.all.each do |page|
      content=page.body.gsub(*args)
      page.body=content
      page.save
    end
  end
end
