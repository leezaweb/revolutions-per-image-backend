require 'rest-client'
require 'json'
require 'active_support/core_ext/object/try'
# require 'pry'

##1000 warner 1553
##22532 universal 511
##25487 sony 1135
##1003 bmg 641
##26126 emi 2452


ROLES = %w[cover painting artwork illustration drawing Cover Painting Artwork Illustration Drawing]


def parse_page(current_page)
  page_json = JSON.parse(current_page)["releases"].map{|x|x["resource_url"]}


  page_albums = page_json.map do |album_url|
    current_album = RestClient.get("#{album_url}?token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN")
    sleep(2)
    JSON.parse(current_album)
  end
  # binding.pry
  has_extras = page_albums.select do |album|
    album.key?("extraartists") && album["extraartists"].count > 0
  end

  has_roles = has_extras.select do |album|
    album["extraartists"].select do |x|
      x.key?("role") && (x.values & ROLES).any?
    end.count > 0

  end

  has_roles.each do |album|

    album_genres = []
    album["styles"].each{|x|album_genres.push(x)} if album["styles"]
    album["genres"].each{|x|album_genres.push(x)} if album["genres"]
    genres = []

    album_artist = album["extraartists"].select do |x|
      x.key?("role") && (x.values & ROLES).any?
    end[0]


    album_genres.each do |genre|
      genres.push(Genre.find_or_create_by(name:genre))
    end

    artist = VisualArtist.find_or_create_by(
      name:album_artist["name"],
      resource_url:album_artist["resource_url"]
    )


    artist_page = RestClient.get("#{album_artist["resource_url"]}?token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN")
    artist.profile = JSON.parse(artist_page)["profile"]
    artist.save

    this_album = Album.find_or_create_by(
      artist:album["artists_sort"],
      title:album["title"],
      year:album["year"]
    )
    this_album.image = album.try(:[],"images").try(:select){|x|x.value?("primary")}.try(:[],0).try(:[],"uri")

    this_album.rating = album.try(:[],"community").try(:[],"rating").try(:[],"average")
    this_album.likes = album.try(:[],"community").try(:[],"rating").try(:[],"count")
    this_album.genres = genres
    this_album.visual_artist = artist
    this_album.save

  end
end

# 2.downto(2) do |count|
#   current_page = RestClient.get("https://api.discogs.com/labels/34504/releases?page=#{count}&token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN")
#   puts "%%%%%%%#{count}#{JSON.parse(current_page)["pagination"]}%%%%%%%%%%%%%"
#   parse_page(current_page)
# end

# 3.downto(2) do |count|#9
# current_page = RestClient.get("https://api.discogs.com/labels/35322/releases?page=#{count}&token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN")
#   puts "%%%%%%%#{count}#{JSON.parse(current_page)["pagination"]}%%%%%%%%%%%%%"
# parse_page(current_page)
# end
#
# 7.downto(2) do |count|#9
# current_page = RestClient.get("https://api.discogs.com/labels/36436/releases?page=#{count}&token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN")
#   puts "%%%%%%%#{count}#{JSON.parse(current_page)["pagination"]}%%%%%%%%%%%%%"
# parse_page(current_page)
# end
#
# 25.downto(2) do |count|
# current_page = RestClient.get("https://api.discogs.com/labels/30436/releases?page=#{count}&token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN")
#   puts "%%%%%%%#{count}#{JSON.parse(current_page)["pagination"]}%%%%%%%%%%%%%"
# parse_page(current_page)
# end
#
# 33.downto(2) do |count|
# current_page = RestClient.get("https://api.discogs.com/labels/9335/releases?page=#{count}&token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN")
#   puts "%%%%%%%#{count}#{JSON.parse(current_page)["pagination"]}%%%%%%%%%%%%%"
# parse_page(current_page)
# end

# 17.downto(2) do |count|#97
# current_page = RestClient.get("https://api.discogs.com/labels/77343/releases?page=#{count}&token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN")
#   puts "%%%%%%%#{count}#{JSON.parse(current_page)["pagination"]}%%%%%%%%%%%%%"
# parse_page(current_page)
# end
#
# 19.downto(2) do |count|
# current_page = RestClient.get("https://api.discogs.com/labels/18955/releases?page=#{count}&token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN")
#   puts "%%%%%%%#{count}#{JSON.parse(current_page)["pagination"]}%%%%%%%%%%%%%"
# parse_page(current_page)
# end
#
# 20.downto(2) do |count|
# current_page = RestClient.get("https://api.discogs.com/labels/886/releases?page=#{count}&token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN")
#   puts "%%%%%%%#{count}#{JSON.parse(current_page)["pagination"]}%%%%%%%%%%%%%"
# parse_page(current_page)
# end
#
# 114.times do |count|
#   current_page = RestClient.get("https://api.discogs.com/labels/24936/releases?page=#{count}&token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN")
#   puts "%%%%%%%#{count}#{JSON.parse(current_page)["pagination"]}%%%%%%%%%%%%%"
#   parse_page(current_page)
# end

# 26.downto(1) do |count|#154
#   current_page = RestClient.get("https://api.discogs.com/labels/1329/releases?page=#{count}&token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN")
#   puts "%%%%%%%#{count}#{JSON.parse(current_page)["pagination"]}%%%%%%%%%%%%%"
#   parse_page(current_page)
# end

180.times do |count|
  current_page = RestClient.get("https://api.discogs.com/labels/238322/releases?page=#{count}&token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN")
  puts "%%%%%%%#{count}#{JSON.parse(current_page)["pagination"]}%%%%%%%%%%%%%"
  parse_page(current_page)
end

626.times do |count|
  current_page = RestClient.get("https://api.discogs.com/labels/651/releases?page=#{count}&token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN")
  puts "%%%%%%%#{count}#{JSON.parse(current_page)["pagination"]}%%%%%%%%%%%%%"
  parse_page(current_page)
end

1556.times do |count|
  current_page = RestClient.get("https://api.discogs.com/labels/681/releases?page=#{count}&token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN")
  puts "%%%%%%%#{count}#{JSON.parse(current_page)["pagination"]}%%%%%%%%%%%%%"
  parse_page(current_page)
end

1590.times do |count|
  current_page = RestClient.get("https://api.discogs.com/labels/11358/releases?page=#{count}&token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN")
  puts "%%%%%%%#{count}#{JSON.parse(current_page)["pagination"]}%%%%%%%%%%%%%"
  parse_page(current_page)
end

2485.times do |count|
  current_page = RestClient.get("https://api.discogs.com/labels/1610/releases?page=#{count}&token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN")
  puts "%%%%%%%#{count}#{JSON.parse(current_page)["pagination"]}%%%%%%%%%%%%%"
  parse_page(current_page)
end





2452.downto(1200) do |count|
  current_page = RestClient.get("https://api.discogs.com/labels/26126/releases?page=#{count}&token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN")
  puts "%%%%%%%#{count}#{JSON.parse(current_page)["pagination"]}%%%%%%%%%%%%%"
  parse_page(current_page)
end
