$(document).ready () ->
  $('.deactivate-corp').each (e) ->
    $(this).unbind('click').click (ev) ->
      ev.preventDefault();
      $.get('/refinery/deactivate_corp/'+$(this).attr('data-corp-id')+'.js', () ->)