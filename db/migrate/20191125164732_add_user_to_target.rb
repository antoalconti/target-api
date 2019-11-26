class AddUserToTarget < ActiveRecord::Migration[5.2]
  def change
    change_table :targets do |t|
      t.references :user, foreign_key: true, null: false
    end
  end
end
