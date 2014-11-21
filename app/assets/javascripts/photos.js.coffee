$.fn.setMaxHeight = (val) ->
  $(this).first().css({
    'max-height' : val + "px"
  })

setMaxMainPhotoHeight = () ->
  $('#main-photo').setMaxHeight($(window).height()-85)

setMaxBlogPhotoViewHeight = () ->
  $('div.blog-photo-view img.blog-photo-img').each ->
      $(this).setMaxHeight($(window).height() * 2/3)

photoBrowserScroller = () ->
  offset = 40
  currentPosition = $(this).scrollTop() + $(this).height()
  firePosition = $(this).prop('scrollHeight') - offset
  console.log(currentPosition+' : '+firePosition)
  if(currentPosition >= firePosition)
    currentCount = $('#photo-browser img').size()
    last = $('#photo-browser img').last().prop('id').match(/photo\_(\d+)/)[1];
    alert('Fire! Count:'+currentCount+' last: '+last);

$(document).ready ->
  $('body').setFadeAble('div.context-item', 'a.control')
  $('body').setFadeAble('#photo-container .nav', 'span')
  $('body').setFadeAble('div.blog-photo-view', 'div.meta-info', 0.7)

  setMaxBlogPhotoViewHeight()
  $(window).resize(setMaxBlogPhotoViewHeight)

  setMaxMainPhotoHeight()
  $(window).resize(setMaxMainPhotoHeight)

  $("#photo-browser").setMaxHeight($(window).height() - 200)
  $('#photo-browser').height($(window).height() - 100)
  $('#photo-browser').scroll(photoBrowserScroller)
