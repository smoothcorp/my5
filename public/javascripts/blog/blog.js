$(document).ready(function () {
    $('.li_year').live('click', function (e) {
        var elem = $(this).children("ul");
        elem.toggle();
    });
    $('.comment_button').live('click', function () {
        $('#comments').toggle('slow');
    });

    $('.print_button').live('click', function () {
        window.print();
    });
    var image_right, image_left, image_center;
    image_right = $('.image-align-right')
    image_left = $('.image-align-left')
    image_center = $('.text-align-center')
    if (image_right)
        image_right.parent().addClass('text-align-right');
    if (image_left)
        image_left.parent().addClass('text-align-left');
    if (image_center)
        $.each(image_center, function () {
            if ($(this).is('img'))
                $(this).parent().addClass('text-align-center');
        });

    $('#copy_body_link').live('click',function () {
        var teaserTextArea = $('#blog_post_custom_teaser')[0];
        var teaserEditor = null;
        $.each(WYMeditor.INSTANCES, function (index, editor) {
            if (editor._element[0] == teaserTextArea) {
                teaserEditor = editor;
            }
        });
        if (teaserEditor) {
            teaserEditor.html($('#blog_post_body').attr('value'));
        }

        var bodyTextArea = $('#blog_post_body')[0];
        var bodyEditor = null;
        $.each(WYMeditor.INSTANCES, function (index, editor) {
            if (editor._element[0] == bodyTextArea) {
                bodyEditor = editor;
            }
        });

        if (teaserEditor && bodyEditor) {
            teaserEditor.html(bodyEditor.html());
        }

        event.preventDefault();
    });
});
