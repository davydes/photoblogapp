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
    @photo = Photo.new
  end

  def edit
  end

  def create
    @photo = current_user.photos.new(photo_new_params)
    if @photo.save
      redirect_to @photo, notice: 'Photo uploaded successfully.'
    else
      render :new
    end
  end

  def update
    if @photo.update(photo_upd_params)
      redirect_to @photo, notice: 'Photo was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @photo.destroy
    redirect_to photos_url, notice: 'Photo was successfully destroyed.'
  end

  private

  def set_photo
    if current_user.admin?
      @photo = Article.find(params[:id])
    else
      @photo = current_user.photos.find(params[:id])
    end
  end

  def photo_new_params
    params.require(:photo).permit(:title, :description, :image)
  end

  def photo_update_params
    params.require(:photo).permit(:title, :description, :image)
  end

  def correct_user
    redirect_to root_path unless admin_or_current?(@photo.user)
  end
end