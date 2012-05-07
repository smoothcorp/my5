/* DO NOT MODIFY. This file was compiled Fri, 28 Oct 2011 01:46:24 GMT from
 * /Users/chrishexton/Desktop/workspaces/rails/my5/app/coffeescripts/my5/mini_modules/body_parts.coffee
 */

(function() {
  $(document).ready(function() {
    return $('.body_part').each(function(element) {
      return $(this).click(function(event) {
        event.preventDefault();
        $('.body_part').each(function() {
          var parent;
          parent = $(this).parent();
          return parent.parent().find('ul').hide();
        });
        return $(this).parent().parent().find('ul').show();
      });
    });
  });
}).call(this);
