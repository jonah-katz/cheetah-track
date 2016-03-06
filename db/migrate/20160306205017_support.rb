class Support < ActiveRecord::Migration
  def change
    create_table :supports do |t|
    	t.string :message
    	t.string :email
    	t.timestamps
    end
  end
end
