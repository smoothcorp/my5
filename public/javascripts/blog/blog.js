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
});
