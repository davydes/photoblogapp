var setMaxArticlePhotoHeight = function() {
    $('div.article-photo-container img').each(function () {
        $(this).setHeightAsWindow(66);
    });
};

$(document).ready(function () {
    setMaxArticlePhotoHeight();
    $(window).resize(setMaxArticlePhotoHeight);
});
