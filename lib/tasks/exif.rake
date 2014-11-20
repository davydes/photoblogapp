namespace :exif do
  desc "Fill missing EXIF"
  task :fill_missing => :environment do
    puts "Fill missing EXIF..."
    Photo.all.where('exif_binary is null').each do |photo|
      filename = Rails.env == 'development' ? photo.image.path : photo.image.url
      puts "update #{photo.title} from #{filename}"
      photo.update_column :exif_binary, Utils::Exif.new(filename).to_binary
      puts "ok. bytes: #{photo.exif_binary.length}"
    end
  end
end