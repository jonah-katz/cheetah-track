class CreateTogglAccounts < ActiveRecord::Migration
  def change
  	drop_table :toggl_accounts_tables
    create_table :toggl_accounts do |t|
	  t.string :api_token
	  t.integer :user_id
      t.timestamps null: false
    end
  end
end
