class AlbumsController < ApplicationController
  before_action :signed_in_user, only: [:new, :edit, :update, :destroy]
  before_action :set_album, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    user = User.find(params[:user_id])
    @albums = user.albums.all
  end

  def show
    user = User.find(params[:user_id])
    @album = user.albums.find(params[:id])
  end

  def new
    @album = current_user.albums.new()
  end

  def edit
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

  def set_album
    if current_user.admin?
      @album = User.find(param[:user_id]).albums.find(params[:id])
    else
      @album = current_user.albums.find(params[:id])
    end
  end

  def album_params
    params.require(:album).permit(:title)
  end

  def correct_user
    redirect_to root_path unless admin_or_current?(@album.user)
  end
end
