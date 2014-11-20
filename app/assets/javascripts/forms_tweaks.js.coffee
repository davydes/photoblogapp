$.fn.setMaxLength = () ->
  maxLength = $(this).attr('maxlenght')
  console.log($(this).innerHTML+', maxLength='+maxLength)
  if maxLength?
    $(this).bind('input propertychange', () ->
      console.log('ssssss')
      if ($(this).val().length > maxLength)
        $(this).val($(this).val().substring(0, maxLength))
        return false;
    )

jQuery ->
  $('textarea[maxlenght]').setMaxLength()
  $('input[maxlenght]').setMaxLength()