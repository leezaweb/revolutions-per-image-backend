class CreateVisualArtists < ActiveRecord::Migration[5.1]
  def change
    create_table :visual_artists do |t|
      t.string :name
      t.string :resource_url
      t.string :profile
      t.timestamps
    end
  end
end
