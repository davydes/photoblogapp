xml.instruct!
xml.urlset(
  'xmlns'.to_sym => "http://www.sitemaps.org/schemas/sitemap/0.9",
  'xmlns:image'.to_sym => "http://www.google.com/schemas/sitemap-image/1.1"
) do
  @static_pages.each do |page|
    xml.url do
      xml.loc "#{page}"
      xml.changefreq("monthly")
    end
  end
  @articles.each do |article|
    xml.url do
      xml.loc "#{article_url(article)}"
      xml.lastmod article.updated_at.strftime("%F")
      xml.changefreq("weekly")
      if article.photos_hash.any?
        xml.image :image do
          xml.image :loc, image_photo_url(article.photos_hash.values[0])
        end
      end
    end
  end
end
