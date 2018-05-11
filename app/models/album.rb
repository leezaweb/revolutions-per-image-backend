class Album < ApplicationRecord
  belongs_to :visual_artist
  has_many :album_genres
  has_many :genres, through: :album_genres
end
