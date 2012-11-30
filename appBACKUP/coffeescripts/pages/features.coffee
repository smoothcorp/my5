$(document).ready ->
    $('.leftbar a').each (i, e) ->
        $(e).click (event) ->
            event.preventDefault()
            $('.leftbar .selected').removeClass('selected')
            $(e).parent('li').addClass('selected')
            $('.feature_content .active').removeClass('active')
            $('#'+$(e).attr('data-sub')).addClass('active')