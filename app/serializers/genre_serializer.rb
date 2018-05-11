class GenreSerializer < ActiveModel::Serializer
  # has_many :album_genres
  # has_many :albums, through: :album_genres
  # has_many :visual_artists, through: :albums
  attributes :id, :name, :album_count
end
