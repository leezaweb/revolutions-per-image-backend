class CreateAlbumGenres < ActiveRecord::Migration[5.1]
  def change
    create_table :album_genres do |t|
      t.references :album
      t.references :genre
      t.timestamps
    end
  end
end
