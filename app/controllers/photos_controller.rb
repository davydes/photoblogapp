class PhotosController < ApplicationController
  before_action :signed_in_user, only: [:new, :edit, :update, :destroy]
  before_action :set_photo, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @photos = Photo.all
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def new
  end

  def edit
  end

  def create
    @photo = current_user.photos.new()
    @photo.title = params[:image][0].original_filename
    @photo.image = params[:image][0]
    if @photo.save
      render file: '/photos/photo.json.erb',
             content_type: 'application/json'
    else
      render file: '/photos/errors.json.erb',
             content_type: 'application/json'
    end
  end

  def update
    if @photo.update(photo_update_params)
      redirect_to @photo, notice: 'Photo was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url, notice: 'Photo was successfully destroyed.' }
      format.json { render file: '/photos/photo.json.erb',
                           content_type: 'application/json' }
    end
  end

  private

  def set_photo
    if current_user.admin?
      @photo = Photo.find(params[:id])
    else
      @photo = current_user.photos.find(params[:id])
    end
  end

  def photo_update_params
    params.require(:photo).permit(:title, :description, :image)
  end

  def correct_user
    redirect_to root_path unless admin_or_current?(@photo.user)
  end
end