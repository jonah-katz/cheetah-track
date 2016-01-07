class CreateTogglAccountsTable < ActiveRecord::Migration
  def change
    create_table :toggl_accounts_tables do |t|
    	t.string :api_token
    	t.integer :user_id
    end
  end
end
