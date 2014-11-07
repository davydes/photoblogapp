class AlbumsController < ApplicationController
  include UserResourceable
  respond_to :html
  respond_to :js, only: [:new, :create]

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
        format.html { redirect_to [@album.user, @album] }
        format.js   { render action: 'show', status: :created, location: [@album.user, @album] }
      else
        format.html { render :new }
        format.js   { render json: @album.errors, status: :unprocessable_entity }
      end
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
    # todo: make destroy remoteable
    @album.destroy
    redirect_to user_albums_path(@album.user)
  end

  private

  def album_params
    params.require(:album).permit(:title)
  end

end
