##
# = 商城 页面 界面
#
class CustomPage::PagesController < ApplicationController
  # layout 'purple/application'

  caches_action :show, :expires_in => 1.hour.to_i, :cache_path => Proc.new { |ctr| ctr.generate_cache_url }

  def show
    @page ||= CustomPage::Page.search(position ||= params[:id]) || CustomPage::Page.new
    respond_to do |format|
      theme = params[:id].match(/mobile/) ? "touch" : "purple"
      format.html { render :show, layout: theme }
      format.xml { @data = @page.to_data }
    end
  end

  def _blank
  end

  def _root_2
  end

  def _brands
  end

  def _root_3
  end

  def _msn
  end

  def _msn2
  end

  def _ultimate
  end

  def _series_link
  end

  def _series_title
  end

  def _series_top
  end

  def _series_a1
  end

  def _series_a2
  end

  def _series_a3
  end

  def _series_a4
  end

  def _series_a5
  end

  def _series_a6
  end

  def _series_a7
  end

  def _series_topics
  end

  def _series_a8
  end

  def _series_brands
  end

  def _flash_root_4
  end

  def _flash_home
  end

  def _flash_treasure
  end

  def _flash_category_1
  end

  def _flash_category_2
  end

  def _flash_category_3
  end

  def _images
  end

  def _weipai
  end

  def _background
  end

  def _cs_problems
  end

  def _flash_root_5
  end

  def weipai
    redirect_to '/shop/pages/weipai?flash'
  end

  private

  def authorized?
    super
    true
  end
end
