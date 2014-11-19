module ArticlesHelper
  def _compile_photo_tags(article, text, photos_hash)
    text.gsub(Article::PHOTO_TAG) do
      if photos_hash.has_key?($1)
        render partial: 'photos/photo_in_blog', locals: { photo: photos_hash[$1], article: article }
      else
        nil
      end
    end
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true)
    options = {
        autolink: true,
        no_intra_emphasis: true,
        fenced_code_blocks: true,
        lax_html_blocks: true,
        strikethrough: true,
        superscript: true,
        space_after_headers: true
    }
    markdown = Redcarpet::Markdown.new(renderer, options)
    markdown.render(text).html_safe
  end

  def html_content_article(article)
    text = strip_tags(article.content)
    text = _compile_photo_tags(article, text, article.photos_hash)
    markdown(text)
  end

  def html_intro_article(article)
    text = strip_tags(article.content)
    text = truncate(text, length: 150, separator: ' ')
    text = text.gsub(Article::PHOTO_TAG, '')
    markdown(text)
  end

end