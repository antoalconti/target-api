class CreateSiteInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :site_infos do |t|
      t.string :info

      t.timestamps
    end
  end
end
