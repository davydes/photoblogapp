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

  $("#photos-area").justifiedGallery({
    sizeRangeSuffixes : {
      'lt100': ''
      'lt240': ''
      'lt320': ''
      'lt500': ''
      'lt640': ''
      'lt1024': ''
    }
    rowHeight : 200
    margins : 3
    captions : true
    captionSettings : {
      animationDuration : 500
      visibleOpacity : 0.7
      nonVisibleOpacity : 0
    }
    refreshTime : 100
  })

  $('#photo-infscrl-page #photos-area').infinitescroll({
    navSelector: "#photo-paginate",
    nextSelector: "#photo-paginate a[rel=next]",
    itemSelector: "#photos-area div.item",
    loading: {
      selector: "#page-loader"
      finishedMsg: ''
      msg: null
      msgText: '<em>Loading...</em>'
    }
  }, () -> $('#photos-area').justifiedGallery('norewind'))
