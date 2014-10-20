module Paperclip
  class Cropper < Thumbnail
    def transformation_command
      crop_command
    end

    def crop_command
      target = @attachment.instance
      if target.cropping?
        " -crop #{target.crop_w}x#{target.crop_h}+#{target.crop_x}+#{target.crop_y}"
      end
    end
  end
end