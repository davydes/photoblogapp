var setMaxPhotoHeight = function (){
    winHeight = $(window).height()-85;
    $('#main-photo').first().css({
        'max-height' : winHeight + "px"
    });
};

var setFadeAble = function(container, baseElementSelector, affectElementSelector) {
    $(container).find(baseElementSelector).on('mouseenter', function (e) {
        $(this).find(affectElementSelector).fadeIn();
    });

    $(container).find(baseElementSelector).on('mouseleave', function(e){
        $(this).find(affectElementSelector).stop().fadeOut();
    });
};

$(document).ready(function () {
    setMaxPhotoHeight();
    setFadeAble('body','div.context-item', 'a.control');
    $(window).resize(setMaxPhotoHeight);
});

