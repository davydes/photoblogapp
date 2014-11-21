$.fn.setMaxLength = () ->
  maxLength = $(this).attr('maxlenght')
  if maxLength?
    $(this).bind('input propertychange', () ->
      if ($(this).val().length > maxLength)
        $(this).val($(this).val().substring(0, maxLength))
        return false;
    )

jQuery ->
  $('textarea[maxlenght]').setMaxLength()
  $('input[maxlenght]').setMaxLength()
