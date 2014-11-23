$(document).ready ->

  $(document).bind('ajaxError', 'form#album-form', (event, jqxhr) ->
    $(event.data).renderFormErrors($.parseJSON(jqxhr.responseText))
  )

  $("#albums-area").justifiedGallery ({
    sizeRangeSuffixes : {
      'lt100': ''
      'lt240': ''
      'lt320': ''
      'lt500': ''
      'lt640': ''
      'lt1024': ''
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
