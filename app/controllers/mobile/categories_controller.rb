class Mobile::CategoriesController < Mobile::ApplicationController
  def index
    @category = Shop::Category.find(1)

    def @category.children;
      self.class.active.published.where({:parent_id => self.id}).map { |child|
        def child.children;
          self.class.active.published.where({:parent_id => self.id});
        end

        ; child };
    end

    @data =@category.assign_options({:only => [:id, :name, :pic], :objects => {:children => {:only => [:id, :name, :pic], :objects => {:children => {:only => [:id, :name, :pic]}}}}}).to_json
    @data=JSON.parse(@data)
    respond_to do |format|
      format.html
    end
  end

  def authorized?
    return true
  end
end
