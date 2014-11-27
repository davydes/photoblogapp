$(document).ready ->

  $("#albums-area").justifiedGallery ({
    sizeRangeSuffixes : {
      'lt100': '_s100', 'lt240': '_s240', 'lt320': '_s320',
      'lt500': '_s500', 'lt640': '_s640', 'lt1024': '_medium'
    }
    rowHeight : 240
    margins : 3
    captions : true
    captionSettings : {
      animationDuration : 500
      visibleOpacity : 1
      nonVisibleOpacity : 0.5
    }
    refreshTime : 100
  })
