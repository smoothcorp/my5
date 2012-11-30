$(document).ready () ->
  $('#corporation_select select').change () ->
    if $(this).val() == ''
      $("#department_select").children("select, div").each () ->
        $(this).remove()
      if $('#customer_role').val() == 'dept_manager' || $('#customer_role').val() == 'standard'
        $("#department_select").append("<div>You must select a corporation</div>")
      else
        $("#department_select").append("<div>N/A</div>")
    else
      if $('#customer_role').val() != 'manager'
        $.get('/refinery/get_departments/'+$('#corporation_select select').val()+'.js', () ->)
  
  $('#customer_role').change () ->
    if $(this).val() == 'manager'
      $("#department_select").children("select, div").each () ->
        $(this).remove()
      $("#department_select").append("<div>N/A</div>")
    else if $(this).val() == 'dept_manager'
      $.get('/refinery/get_departments/'+$('#corporation_select select').val()+'.js', () ->)
    else
      if $('#corporation_select select').val() != ''
        $.get('/refinery/get_departments/'+$('#corporation_select select').val()+'.js', () ->)
        