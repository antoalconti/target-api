class AddFielSeenToMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :seen, :boolean, null: false, default: 'false'
  end
end
