  class Api::V1::AlbumsController < ApplicationController

    def index
      offset = params[:page] == "undefined" ? 0 : params[:page].to_i
      limit = 20
      sort = params[:sort] || "rating"

      order = "DESC" if sort == "rating"
      order = "DESC" if sort == "likes"
      order = "ASC" if sort == "year"
      puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%#{offset}"
      # byebug
      render json: Album.order("#{sort} #{order}").limit(limit).offset(offset*limit)
    end

    def update
      @album = Album.find(params[:id])
      @album.likes+=1
      @album.save
      render json: Album.find(params[:id]), include: ['visual_artist']
    end

    def count
      count = Album.count
      # Album.where("image is NULL").destroy_all
      render json: {count:count}
    end

    def destroy
      Album.find(params[:id]).destroy
    end

    def create
      va = VisualArtist.find_or_create_by(name: params[:visual_artist])
      album = Album.find_or_create_by(
        artist: params[:artist],
        title: params[:title],
        year: params[:year]
      )

      genreParams = params[:genres].split(",")
      genres = genreParams.map{|x|
        Genre.find_or_create_by(name:x)
      }
      album.visual_artist = va
      album.rating = params[:ratings]
      album.image = params[:image]
      album.likes = params[:likes]
      album.genres = genres
      album.save

    end

    def search
      name = params[:name].titleize
      render json: Album.where("title ILIKE ?", "%#{name}%").or(Album.where("artist ILIKE ?", "%#{name}%")).to_json(include: [visual_artist: {include: :albums}])
    end
  end
