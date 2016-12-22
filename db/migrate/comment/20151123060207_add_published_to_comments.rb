class AddPublishedToComments < ActiveRecord::Migration
  def change
    add_column "comments","published",:boolean,limit: 1,default: false, null: false
  end
end
