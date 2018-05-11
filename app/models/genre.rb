class Genre < ApplicationRecord
  has_many :album_genres
  has_many :albums, through: :album_genres
  has_many :visual_artists, through: :albums
  attr_reader :album_count


  def album_count
    self.albums.count
  end
end
