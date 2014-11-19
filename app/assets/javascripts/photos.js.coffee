$.fn.setMaxHeight = (val) ->
  $(this).first().css({
    'max-height' : val + "px"
  })

setMaxMainPhotoHeight = () ->
  $('#main-photo').setMaxHeight($(window).height()-85)

setMaxBlogPhotoViewHeight = () ->
  $('div.blog-photo-view img.blog-photo-img').each ->
      $(this).setMaxHeight($(window).height() * 2/3)

$(document).ready ->
  setMaxBlogPhotoViewHeight()
  setMaxMainPhotoHeight()
  $(window).resize(setMaxBlogPhotoViewHeight)
  $(window).resize(setMaxMainPhotoHeight)
  $('body').setFadeAble('div.context-item', 'a.control')
  $('body').setFadeAble('#photo-container .nav', 'span')
  $('body').setFadeAble('div.blog-photo-view', 'div.meta-info', 0.7)
