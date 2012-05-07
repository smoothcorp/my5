/* DO NOT MODIFY. This file was compiled Wed, 07 Sep 2011 03:14:28 GMT from
 * /Users/chrishexton/Desktop/workspaces/rails/my5/app/coffeescripts/my5/symptomatics/index.coffee
 */

(function() {
  $(document).ready(function() {
    return $('.part').each(function(i, part) {
      return $(part).hover(function() {
        return $('#current_part').text($(this).attr("data-part"));
      });
    });
  });
}).call(this);
