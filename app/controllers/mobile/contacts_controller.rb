class Mobile::ContactsController < Mobile::ApplicationController
  def index
  end

  def show
   @contact=Shop::Contact.find(params[:id])
   @contact.update_column(:created_at,Time.now)
   redirect_to new_trade_path
  end

  def current_app
    @current_app ||= AUCTION_APP
  end
end
