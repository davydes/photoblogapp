Paperclip::Attachment.default_options.update({
  :hash_data=>":class/:attachment/:id",
  :hash_digest=>"SHA1",
  :path=>":rails_root/public:url",
  :url=>"/system/:class/:attachment/:hash/:id_:style:dotextension",
  :hash_secret => ENV['PAPERCLIP_HASH_SECRET']
})