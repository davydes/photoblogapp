class AlbumsController < ApplicationController
  include UserResource

  before_filter :set_resource, only: [:unlink_photo, :link_photo]

  def index
    @albums = @owner.albums.all
  end

  def show
    @album = @owner.albums.find(params[:id])
  end

  def new
    @album = current_user.albums.new()
  end

  def link_photo
    @photo = @owner.photos.find(params[:photo_id])
    @album.photos << @photo
    respond_to do |format|
      format.json { render file: '/photos/photo.json.erb',
                           content_type: 'application/json' }
      format.html { redirect_to [@album.user, @album], notice: 'Photo was successfully added to album.' }
    end
  end

  def unlink_photo
    @photo = @album.photos.find(params[:photo_id])
    @album.photos.delete(@photo)
    respond_to do |format|
      format.json { render file: '/photos/photo.json.erb',
                           content_type: 'application/json' }
      format.html { redirect_to [@album.user, @album], notice: 'Photo was successfully removed form album.' }
    end
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
