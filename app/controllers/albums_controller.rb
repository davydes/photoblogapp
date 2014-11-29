class AlbumsController < ApplicationController
  include UserResourceable

  def index
    @albums = current_user.albums.all
  end

  def show
    @album = Album.find(params[:id])
  end

  def new
    @album = current_user.albums.new()
    render :album_form
  end

  def create
    @album = current_user.albums.new(album_params)
    save_and_render
  end

  def edit
    render :album_form
  end

  def update
    @album.assign_attributes(album_params)
    save_and_render
  end

  def destroy
    @album.destroy
    respond_to do |format|
      format.html { redirect_to albums_path }
      format.js
    end
  end

  private

  def album_params
    params.require(:album).permit(:title)
  end

  def save_and_render
    respond_to do |format|
      if @album.save
        format.html { redirect_to @album }
        format.js
      else
        format.html { render :album_form }
        format.js   { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end
end