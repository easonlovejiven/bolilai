require "active_resource"
class ApplicationController < ActionController::Base
  # layout 'purple/application'
  include GenerateFormatExt
  include UserCookie
  include Auth
  before_action :login_filter
  before_action :user_cookies
  include RespondToXml
  around_filter :respond_to_xml
  protect_from_forgery with: :exception
  # before_action :authenticate_user!, :except => [:notify]
  skip_before_action :verify_authenticity_token
  before_action :preprocess_params

  def generate_cache_url
    cache_url = request.fullpath.gsub(/_weimall_session=[^&]*/, '')
    if self.is_a?(CustomPage::PagesController) && ['root', 'mobile_root'].include?(params[:id])
      page = CustomPage::Page.find_by!(position: params[:id])
      cache_url = page_path(page).to_s
    end
    if params[:subdomain].present?
      cache_url = "/mobile#{cache_url}"
    end
    cache_url
  end

  def can?(*argv)
    @current_user.try(:can?, *argv)
  end

  def preprocess_params
    params[:page] = nil if params[:page] == ''
    params[:per_page] = nil if params[:per_page] == ''
    params[:format] = nil if params[:format] == ''
    # params[:engine] ||= 'solr'
    # sleep 10
  end

  protected

  def database_transaction
    begin
      ActiveRecord::Base.transaction do
        yield
      end
      true
    rescue => e
      logger.error %[#{e.class.to_s} (#{e.message}):\n\n #{e.backtrace.join("\n")}\n\n]
      false
    end
  end
end
