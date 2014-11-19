setMaxMainPhotoHeight = () ->
  $('#main-photo').setHeightAsWindow(85)

setMaxBlogPhotoViewHeight = () ->
  height = $(window).height()/3
  $('div.blog-photo-view img.blog-photo-img').each ->
      $(this).setHeightAsWindow(height)

$(document).ready ->
  setMaxBlogPhotoViewHeight()
  setMaxMainPhotoHeight()
  $(window).resize(setMaxBlogPhotoViewHeight)
  $(window).resize(setMaxMainPhotoHeight)
  $('body').setFadeAble('div.context-item', 'a.control')
  $('body').setFadeAble('#photo-container .nav', 'span')
  $('body').setFadeAble('div.blog-photo-view', 'div.meta-info', 0.7)
