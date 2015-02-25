module Utils
  class Exif
    def initialize(filename = nil)
      if filename
        begin
          filename = URI::regexp =~ filename ? (tmpfile = LocalResource.from_url(filename).file).path : filename
          @exif = MiniExiftool.new(filename, {:ignore_minor_errors => true}).to_hash
        ensure
          if tmpfile
            tmpfile.close
            tmpfile.unlink
          end
        end
      end
    end

    def initialize_from_binary(binary)
      @exif = Marshal.load(binary)
    end

    def to_binary
      Marshal.dump(@exif)
    end

    def tags
      tags = @exif.keys.compact
      tags.select { |t| !t.start_with?('ExifToolVersion') }
    end

    def priority_tags
      tags = %w(Model ISO ExposureTime FNumber FocalLength CreateDate)
      @exif.keys.compact.select { |t| tags.include?(t) }
    end

    def [] tag
      if tag.eql?('Model') and !@exif['Model'].nil? and !@exif['Make'].nil? and !@exif['Model'].include?(@exif['Make'])
        @exif['Make']+' '+@exif['Model']
      else
        @exif[tag]
      end
    end

    def self.from_binary(binary)
      instance = Exif.new
      instance.initialize_from_binary binary
      instance
    end

    def exists?
      !@exif.nil?
    end
  end
end