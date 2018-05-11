class CreateAlbums < ActiveRecord::Migration[5.1]
  def change
    create_table :albums do |t|
      t.string :artist
      t.string :title
      t.string :image
      t.integer :year
      t.float :rating
      t.integer :likes
      t.references :visual_artist
      t.timestamps
    end
  end
end
