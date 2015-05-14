class PhotosController < ApplicationController
  include UserResourceable
  skip_before_action :signed_in_user, only: [:index, :show]
  before_action :set_context, only: :show
  before_action :set_photo, only: [:unlink_album, :link_album, :available_albums]
  before_action :set_album, only: [:unlink_album, :link_album]

  respond_to :html, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  respond_to :json, only: [:create, :destroy]
  respond_to :js,   only: [:show, :unlink_album, :link_album, :available_albums]

  def index
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
    @photos = @user.photos.all.page(params[:page])
  end

  def show
    @photo = Photo.contextual(@context).find(params[:id])
  end

  def new
    @max_files = current_user.upload_photo_available
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
    respond_to do |format|
      if @photo.update(photo_update_params)
        format.html { redirect_to @photo }
        format.js
      else
        format.html { render :edit }
        format.js   { render json: @photo.errors, status: :unprocessable_entity }
      end
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

  def set_context
    @context = nil
    context_string = params[:context]
    /\A(?<entity>article|album)\-(?<id>\d+)\z/.match(context_string) { |m|
      context = Object.const_get(m[:entity].classify)
      raise "#{m[:entity]} #{m[:id]} does not exists" unless context.exists?(m[:id])
      @context = context.find(m[:id])
    }
  end

  def set_album
    @album = current_user.albums.find(params[:album_id])
  end

  def image_param
    image = params.require(:image)
    image[0] if image.is_a?(Array)
  end

  def photo_update_params
    params.require(:photo).permit(:title, :description)
  end
end