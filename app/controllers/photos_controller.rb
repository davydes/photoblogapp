class PhotosController < ApplicationController
  include UserResourceable
  before_action :set_photo, only: [:unlink_album, :link_album, :available_albums]
  before_action :set_album, only: [:unlink_album, :link_album]

  respond_to :html, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  respond_to :json, only: [:create, :destroy]
  respond_to :js,   only: [:unlink_album, :link_album, :available_albums]

  def index
    @photos = current_user.photos.all.order('created_at DESC').limit(100)
  end

  def show
    @photo = Photo.find(params[:id])
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
    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo }
        format.json { render file: '/photos/photo.json.erb',
                             content_type: 'application/json' }
      else
        format.html { render 'new' }
        format.json { render file: '/photos/errors.json.erb',
                             content_type: 'application/json' }
      end
    end
  end

  def update
    if @photo.update(photo_update_params)
      redirect_to @photo
    else
      render :edit
    end
  end

  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { render file: '/photos/photo.json.erb',
                           content_type: 'application/json' }
    end
  rescue ActiveRecord::DeleteRestrictionError => e
    @photo.errors.add(:base, e)
    flash[:error] = "#{e}"
    redirect_to @photo
  end

  def link_album
    @photo.albums << @album
  end

  def unlink_album
    @photo.albums.delete(@album)
  end

  def available_albums
    already_in_albums = @photo.albums
    all_albums = @photo.user.albums
    @albums = all_albums - already_in_albums
  end

  private

  def set_photo
    set_resource
  end

  def set_album
    @album = current_user.albums.find(params[:album_id])
  end

  def image_param
    image = params.require(:image)
    image[0] if image.is_a?(Array)
  end

  def photo_update_params
    params.require(:photo).permit(:title, :description, :image)
  end
end