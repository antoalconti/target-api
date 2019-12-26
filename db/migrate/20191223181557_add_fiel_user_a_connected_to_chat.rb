class AddFielUserAConnectedToChat < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :user_a_connected, :boolean, null: false, default: false
    add_column :chats, :user_b_connected, :boolean, null: false, default: false
  end
end
