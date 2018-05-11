class AlbumSerializer < ActiveModel::Serializer
  belongs_to :visual_artist, serializer: VisualArtistSerializer
  has_many :genres
  attributes :id, :artist, :title, :image, :year, :rating, :likes, :visual_artist, :genres

end
