$(document).ready () ->
  $('.body_part').each (element) ->
    $(this).click (event) ->
      event.preventDefault()
      $('.body_part').each () ->
        parent = $(this).parent()
        #unless parent.attr('class') == 'selected'
        parent.parent().find('ul').hide()
      $(this).parent().parent().find('ul').show()