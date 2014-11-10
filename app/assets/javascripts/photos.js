var setMaxPhotoHeight = function() {
    $('#main-photo').setHeightAsWindow(85);
};

$(document).ready(function () {
    $('body').setFadeAble('div.context-item', 'a.control');
    setMaxPhotoHeight();
    $(window).resize(setMaxPhotoHeight);
});

