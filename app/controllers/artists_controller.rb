class ArtistsController < ApplicationController
  before_action :set_artist, only: %i[show edit update]

  def show
  end

  def new
    @artist = Artist.new
  end

  def create
    @artist = Artist.new(artist_params)

    @artist.user = current_user
    # authorize @artist

    if @artist.save!
      redirect_to artist_path(@artist)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @artist.update(artist_params)
      redirect_to artist_path(@artist)
    else
      render :show
    end
  end

  private

  def artist_params
    params.require(:artist).permit(:name, :age, :location, :bio, :influences, :genres, :soundcloud_url, :website_url,
                                   :youtube_url, :instagram_url)
  end

  def set_artist
    @artist = Artist.find(params[:id])
    # authorize @artist
  end
end
