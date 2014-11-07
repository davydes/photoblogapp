$(document).ready(function(){
    $(document).bind('ajaxError', 'form#album-form', function(event, jqxhr, settings, exception){
        // note: jqxhr.responseJSON undefined, parsing responseText instead
        $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );
    });
});
