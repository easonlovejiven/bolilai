class InfoController < ApplicationController
  theme "purple"
  def show
    @page ||= ::Cms::Page.where("id=? or url=?", params[:id], params[:id]).first

    if @page.blank?
      @page = CustomPage::Page.new
    end
    if ['post', 'list'].include?(params[:id])
      render params[:id]
    end
  end

end
