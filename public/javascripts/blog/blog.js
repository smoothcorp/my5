$(document).ready(function () {
    $('.li_year').live('click', function (e) {
        var elem = $(this).children("ul");
        elem.toggle();
    });
});
