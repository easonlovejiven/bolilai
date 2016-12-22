# 重设密码
#
class Home::ResetController < Home::ApplicationController # :nodoc: all
	include SimpleCaptcha::ControllerHelpers
	
	def index # :nodoc:
		redirect_to :action => :new
	end
	
	# == Function
	# 
	# 发送重置邮件
	# 
	# == Route
	# 
	# POST /reset
	# 
	# == Parameters
	# 
	# email :: 用户邮箱 *
	# 
	# == Response
	# 
	# 返回空
	# 
	# === XML
	# 
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#   </response>
	# 
	# === JSON
	# 
	#   {
	#   }
	#
	def create
		if simple_captcha_valid? && @account = Core::Account.find_by_email(params[:email])
			Core::Mailer.mail(
				:recipients => @account.email,
				:subject => %[重置密码],
				:template => 'reset',
				:body => { :account => @account }
			)
			respond_to do |format|
				format.html { redirect_to :action => 'edit', :id => @account.id }
				format.xml
			end
		else
			flash[:notice] = '输入不正确'
			respond_to do |format|
				format.html { render :action => 'new' }
				format.xml { raise ActiveResource::ResourceInvalid.new(response) }
			end
		end
	end
	
	def edit # :nodoc:
		@account = Core::Account.find_by_id(params[:id])
		
		respond_to do |format|
			format.html { redirect_to :action => 'new' if !@account }
			format.js { render :text => '' }
		end
	end
	
	private
	
	def authorized?
		true
	end
end
