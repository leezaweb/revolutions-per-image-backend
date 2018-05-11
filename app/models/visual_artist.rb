class VisualArtist < ApplicationRecord
  has_many :albums
  has_many :album_genres, through: :albums
  has_many :genres, through: :album_genres
end
