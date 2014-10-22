Paperclip::Attachment.default_options.update({
  :hash_data=>":class/:attachment/:id",
  :hash_digest=>"SHA1",
  :hash_secret => ENV['PAPERCLIP_HASH_SECRET'],
  :path=>":rails_root/public:url",
  :url=>"/system/:class/:attachment/:hash/:id_:style:dotextension"
})