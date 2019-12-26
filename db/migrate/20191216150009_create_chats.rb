class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.references :user_a
      t.references :user_b

      t.timestamps
    end

    add_foreign_key :chats, :users, column: :user_a_id, primary_key: :id
    add_foreign_key :chats, :users, column: :user_b_id, primary_key: :id
  end
end
