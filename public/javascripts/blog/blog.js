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
});
