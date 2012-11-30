/* DO NOT MODIFY. This file was compiled Thu, 24 Nov 2011 01:47:26 GMT from
 * /Users/chrishexton/Desktop/workspaces/rails/my5/app/coffeescripts/my5/admin/customers/get_departments.coffee
 */


  $(document).ready(function() {
    $('#corporation_select select').change(function() {
      if ($(this).val() === '') {
        $("#department_select").children("select, div").each(function() {
          return $(this).remove();
        });
        if ($('#customer_role').val() === 'dept_manager' || $('#customer_role').val() === 'standard') {
          return $("#department_select").append("<div>You must select a corporation</div>");
        } else {
          return $("#department_select").append("<div>N/A</div>");
        }
      } else {
        if ($('#customer_role').val() !== 'manager') {
          return $.get('/refinery/get_departments/' + $('#corporation_select select').val() + '.js', function() {});
        }
      }
    });
    return $('#customer_role').change(function() {
      if ($(this).val() === 'manager') {
        $("#department_select").children("select, div").each(function() {
          return $(this).remove();
        });
        return $("#department_select").append("<div>N/A</div>");
      } else if ($(this).val() === 'dept_manager') {
        return $.get('/refinery/get_departments/' + $('#corporation_select select').val() + '.js', function() {});
      } else {
        if ($('#corporation_select select').val() !== '') {
          return $.get('/refinery/get_departments/' + $('#corporation_select select').val() + '.js', function() {});
        }
      }
    });
  });
