class AlbumgenreSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :album
  belongs_to :genre
end
