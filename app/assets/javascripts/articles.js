var setMaxArticlePhotoHeight = function() {
    $('div.blog-photo-view img.blog-photo-img').each(function () {
        $(this).setHeightAsWindow($(window).height()/2);
    });
};

$(document).ready(function () {
    setMaxArticlePhotoHeight();
    $(window).resize(setMaxArticlePhotoHeight);
});
