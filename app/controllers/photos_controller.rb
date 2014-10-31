class PhotosController < ApplicationController
  before_action :signed_in_user, only: [:new, :edit, :update, :destroy]
  before_action :set_photo, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @user = User.find(params[:user_id]);
    @photos = @user.photos.all.order('created_at DESC').limit(100)
  end

  def show
    @photo = User.find(params[:user_id]).photos.find(params[:id])
  end

  def new
    @max_files = [Photo::LIMIT_PHOTOS_DAILY - current_user.photos.today.count, Photo::LIMIT_PHOTOS_WEEKLY - current_user.photos.this_week.count].min
    flash.now[@max_files > 0 ? :notice : :error] = I18n.t 'photos.uploader.messages.uploadLimit', count: @max_files
  end

  def edit
  end

  def create
    image = image_param
    @photo = current_user.photos.new()
    @photo.title, @photo.image = image.original_filename, image
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
      redirect_to [@photo.user, @photo], notice: 'Photo was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to user_photos_url(@photo.user), notice: 'Photo was successfully destroyed.' }
      format.json { render file: '/photos/photo.json.erb',
                           content_type: 'application/json' }
    end
  end

  private

  def set_photo
    if current_user.admin?
      @photo = User.find(param[:user_id]).photos.find(params[:id])
    else
      @photo = current_user.photos.find(params[:id])
    end
  end

  def image_param
    image = params.require(:image)
    image[0] if image.is_a?(Array)
  end

  def photo_update_params
    params.require(:photo).permit(:title, :description, :image)
  end

  def correct_user
    redirect_to root_path unless admin_or_current?(@photo.user)
  end
end