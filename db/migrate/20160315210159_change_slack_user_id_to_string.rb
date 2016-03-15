class ChangeSlackUserIdToString < ActiveRecord::Migration
  def change
  	change_column :toggl_accounts, :slack_user_id, :string
  end
end
