module Api
  module V1
    class GenresController < ApplicationController

      def index
        #render json: Genre.all
        render json: Genre.joins(:albums).group('genres.id').having('count(album_genres.album_id)> ?', 15).order('count(album_genres.album_id) ASC')

        # render json: Genre.joins(:albums).where('COUNT(genre.id) > ?', 50)
      end


      def filter
        puts "@@@@@@@@@#{params[:ids]}"
        ids = params[:ids].split(",")

        render json: Genre.where(id:ids).to_json(include: [albums: { include: [visual_artist: {include: :albums}]}])
      end


    end
  end

end
