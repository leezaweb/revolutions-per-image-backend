class Api::V1::VisualArtistsController < ApplicationController

    def index
      render json: VisualArtist.all.order(created_at: :asc)
    end


    def names
      render json: VisualArtist.all.map{|x|x.name}
    end

    def filter
      name = params[:name].titleize

      render json: VisualArtist.where(name:name).to_json(include: [albums: { include: [visual_artist:{include: :albums}]}])
    end

end
