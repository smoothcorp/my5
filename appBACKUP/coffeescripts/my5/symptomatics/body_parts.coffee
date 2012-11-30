$(document).ready ->
    $('.part, .part .sub').each (i, part) ->
        $(part).hover( () ->
                $('#current_part').text($(this).attr("data-part"))
            )