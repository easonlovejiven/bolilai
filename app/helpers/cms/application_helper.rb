module Cms::ApplicationHelper
  def cms_cate_link(cate)
    cate.url
  end

  def cms_page_link(page)
    if !page.category.blank?
      "#{page.category.url}?page_id=#{page.id}"
    else
      cms_page_path(page)
    end
  end

  def visit_cms_cate_link(cate)
    cms_cate_link(cate)
  end

  def visit_article_link(page)
    if page.category.root && page.category.root.template_type=="default"
     "#{cms_cate_link(page.category.root)}?page_id=#{page.id}"
    else
      cms_page_path(page)
    end
  end
end
