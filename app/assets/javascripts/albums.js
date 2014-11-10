$(document).ready(function(){
    $(document).bind('ajaxError', 'form#album-form', function(event, jqxhr){
        $(event.data).renderFormErrors( $.parseJSON(jqxhr.responseText) );
    });
});
