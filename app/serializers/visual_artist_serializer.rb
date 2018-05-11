class VisualArtistSerializer < ActiveModel::Serializer
  has_many :albums, serializer: AlbumSerializer
  has_many :album_genres, through: :albums
  has_many :genres, through: :album_genres
  attributes :id, :name, :resource_url, :profile, :albums
end
