  class Api::V1::AlbumsController < ApplicationController
    def create
      puts "@@@@@@@@@@@#{params}"
    end

    def index
      offset = params[:page] == "undefined" ? 0 : params[:page].to_i
      limit = 18
      sort = params[:sort] || "id"

      order = "DESC" if sort == "id"
      order = "DESC" if sort == "likes"
      order = "ASC" if sort == "year"
      puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%#{offset}"
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
      Album.where("image is NULL").destroy_all
      render json: {count:count}
    end

    def destroy
      Album.find(params[:id]).destroy
    end

    def search
      name = params[:name].titleize
      render json: Album.where("title LIKE ?", "%#{name}%").or(Album.where("artist LIKE ?", "%#{name}%")).to_json(include: [visual_artist: {include: :albums}])
    end
  end
