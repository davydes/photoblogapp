class AlbumsController < ApplicationController
  include UserResource

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
    respond_to do |format|
      if @album.save
        format.html { redirect_to [@album.user, @album], notice: 'Album was successfully created.' }
        format.json { render :show, status: :created, location: [@album.user, @album] }
      else
        format.html { render :new }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to [@album.user, @album], notice: 'Album was successfully updated.' }
        format.json { render :show, status: :ok, location: [@album.user, @album] }
      else
        format.html { render :edit }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @album.destroy
    respond_to do |format|
      format.html { redirect_to user_albums_path(@album.user), notice: 'Album was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def album_params
    params.require(:album).permit(:title)
  end

end
