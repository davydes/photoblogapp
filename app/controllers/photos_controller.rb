class PhotosController < ApplicationController
  include UserResource

  def index
    @photos = @owner.photos.all.order('created_at DESC').limit(100)
  end

  def show
    @photo = @owner.photos.find(params[:id])
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

  def image_param
    image = params.require(:image)
    image[0] if image.is_a?(Array)
  end

  def photo_update_params
    params.require(:photo).permit(:title, :description, :image)
  end

end