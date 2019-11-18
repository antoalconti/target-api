class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.column :name, :string, null: false
      t.timestamps
    end

    add_index :topics, :name, unique: true
  end
end
