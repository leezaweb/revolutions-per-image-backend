require 'rest-client'
require 'json'
require 'pry'


# url = "https://api.discogs.com/database/search?q=petagno&?credit&token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN"

##1000 warner
##22532universal
##25487 sony
##1003 bmg
##26126 emi


ROLES = ["cover","painting","artwork","illustration","drawing","Cover","Painting","Artwork","Illustration","Drawing"]
# per_page=20&

1..347.times do |count|
  current_page = RestClient.get("https://api.discogs.com/labels/1000/releases?page=#{count}")
  page_json = JSON.parse(current_page)["releases"].map{|x|x["resource_url"]}

  snip = page_json[0,20]

  page_albums = snip.map do |album_url|
    current_album = RestClient.get(album_url)
    JSON.parse(current_album)
  end

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
    album["styles"].each{|x|album_genres.push(x)}
    album["genres"].each{|x|album_genres.push(x)}
    genres = []
    binding.pry

    album_artist = album["extraartists"].select do |x|
      x.key?("role") && (x.values & ROLES).any?
    end[0]

    album_genres.each do |genre|
      genres.push(Genre.find_or_create_by(name:genre))
    end

    artist = Visual_artist.find_or_create_by(
      name:album_artist["name"],
      resource_url:album_artist["resource_url"]
    )

    Album.find_or_create_by(
      artist:album["artists_sort"],
      title:album["title"],
      year:album["year"],
      rating:album["community"]["rating"]["average"],
      likes: album["community"]["rating"]["count"],
      genres: genres,
      visual_artist: artist
    )



  end

end




# fetch("https://api.discogs.com/database/search?q=petagno&?credit&token=QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN").then(response=>response.json()).then(jsonResponse=>{
#   console.log(jsonResponse);
# })
