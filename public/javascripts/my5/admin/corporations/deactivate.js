/* DO NOT MODIFY. This file was compiled Mon, 14 Nov 2011 06:08:26 GMT from
 * /Users/chrishexton/Desktop/workspaces/rails/my5/app/coffeescripts/my5/admin/corporations/deactivate.coffee
 */

(function() {
  $(document).ready(function() {
    return $('.deactivate-corp').each(function(e) {
      return $(this).unbind('click').click(function(ev) {
        ev.preventDefault();
        return $.get('/refinery/deactivate_corp/' + $(this).attr('data-corp-id') + '.js', function() {});
      });
    });
  });
}).call(this);
