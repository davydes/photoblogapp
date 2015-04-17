require 'loofah/helpers'

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
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, escape_html: true)
    options = {
        autolink: true,
        no_intra_emphasis: true,
        fenced_code_blocks: true,
        lax_html_blocks: true,
        strikethrough: true,
        superscript: true,
        space_after_headers: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text)
  end

  def html_content_article(article)
    text = markdown(article.content)
    _compile_photo_tags(article, text, article.photos_hash).html_safe
  end

  def html_intro_article(article)
    h article.intro
  end

end