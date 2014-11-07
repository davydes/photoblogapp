class AlbumsController < ApplicationController
  include UserResourceable

  def index
    @albums = @owner.albums.all
  end

  def show
    @album = @owner.albums.find(params[:id])
  end

  def new
    @album = current_user.albums.new()
    render :album
  end

  def create
    @album = current_user.albums.new(album_params)
    respond_to do |format|
      if @album.save
        format.html { redirect_to [@album.user, @album] }
        format.js   { render action: 'show', status: :created, location: [@album.user, @album] }
      else
        format.html { render :album }
        format.js   { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    render :album
  end

  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to [@album.user, @album] }
        format.js   { render 'update' }
      else
        format.html { render :album }
        format.js   { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # todo: make destroy remoteable
    @album.destroy
    respond_to do |format|
      format.html { redirect_to user_albums_path(@album.user) }
      format.js   { render 'destroy' }
    end
  end

  private

  def album_params
    params.require(:album).permit(:title)
  end

end
