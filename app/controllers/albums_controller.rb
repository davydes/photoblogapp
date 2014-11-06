class AlbumsController < ApplicationController
  include UserResource
  respond_to :html

  def index
    @albums = @owner.albums.all
  end

  def show
    @album = @owner.albums.find(params[:id])
  end

  def new
    @album = current_user.albums.new()
  end

  def create
    @album = current_user.albums.new(album_params)
    if @album.save
      redirect_to [@album.user, @album]
    else
      render :new
    end
  end

  def update
    if @album.update(album_params)
      redirect_to [@album.user, @album]
    else
      render :edit
    end
  end

  def destroy
    @album.destroy
    redirect_to user_albums_path(@album.user)
  end

  private

  def album_params
    params.require(:album).permit(:title)
  end

end
