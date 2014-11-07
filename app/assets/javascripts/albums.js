$(document).ready(function(){
    $(document).bind('ajaxError', 'form#album-form', function(event, jqxhr){
        $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );
    });
});
