class AddUsernameAndUsertypeToUsersusername < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :user_type, :integer
    add_column :users, :username, :string
  end
end
