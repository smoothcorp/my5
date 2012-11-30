/* DO NOT MODIFY. This file was compiled Fri, 28 Oct 2011 06:47:17 GMT from
 * /Users/chrishexton/Desktop/workspaces/rails/my5/app/coffeescripts/my5/symptomatics/body_parts.coffee
 */

(function() {
  $(document).ready(function() {
    return $('.part, .part .sub').each(function(i, part) {
      return $(part).hover(function() {
        return $('#current_part').text($(this).attr("data-part"));
      });
    });
  });
}).call(this);
