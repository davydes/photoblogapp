$.fn.setMaxHeight = (val) ->
  $(this).first().css({
    'max-height' : val + "px"
  })

setMaxMainPhotoHeight = () ->
  $('#main-photo').setMaxHeight($(window).height()-85)

setMaxBlogPhotoViewHeight = () ->
  $('div.blog-photo-view img.blog-photo-img').each ->
      $(this).setMaxHeight($(window).height() * 2/3)

$.fn.cacheImages = () ->
  array = []
  list = []
  $(this).find('a').each ->
    array.push($(this).attr('href'))
  if (array.length > 0)
    for i in [0..array.length-1]
      img = new Image();
      img.onload = () ->
        index = list.indexOf(this);
        if (index != -1)
          list.splice(index, 1)
      list.push(img);
      img.src = array[i]

$(document).ready ->
  setMaxBlogPhotoViewHeight()
  setMaxMainPhotoHeight()
  $(window).resize(setMaxBlogPhotoViewHeight)
  $(window).resize(setMaxMainPhotoHeight)
  $('body.photos-show')
    .setFadeAble('div.context-item', 'a.control')
    .setFadeAble('#photo-container', '.nav span')
    .setFadeAble('#photo-container', '.votes')
    .setFadeAble('#photo-container', '.impressions')
  $('body.articles-show').setFadeAble('div.blog-photo-view', 'div.meta-info', 0.7)

  $("#justified-photos").justifiedGallery({
    sizeRangeSuffixes : {
      'lt100': '_s100', 'lt240': '_s240', 'lt320': '_s320',
      'lt500': '_s500', 'lt640': '_s640', 'lt1024': '_medium'
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

  $('#photo-infscrl-page #justified-photos').infinitescroll({
    debug: true
    navSelector: "#photo-paginate"
    nextSelector: "#photo-paginate a[rel=next]"
    itemSelector: "#justified-photos div.item"
    loading: {
      selector: "#page-loader"
      finishedMsg: ''
      msg: null
      msgText: '<em>Loading...</em>'
    }
  }, () -> $('#justified-photos').justifiedGallery('norewind'))

  $(document).keydown (e) ->
    switch e.which
      when 37
        $('#prev').click();
      when 39
        $('#next').click();

  $('div.hidden-cache').cacheImages();
