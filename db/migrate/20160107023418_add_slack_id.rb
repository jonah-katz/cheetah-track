class AddSlackId < ActiveRecord::Migration
  def change
  	add_column :toggl_accounts, :slack_user_id, :integer
  end
end
