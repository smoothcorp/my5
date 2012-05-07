/* DO NOT MODIFY. This file was compiled Wed, 26 Oct 2011 23:33:30 GMT from
 * /Users/chrishexton/Desktop/workspaces/rails/my5/app/coffeescripts/pages/features.coffee
 */

(function() {
  $(document).ready(function() {
    return $('.leftbar a').each(function(i, e) {
      return $(e).click(function(event) {
        event.preventDefault();
        $('.leftbar .selected').removeClass('selected');
        $(e).parent('li').addClass('selected');
        $('.feature_content .active').removeClass('active');
        return $('#' + $(e).attr('data-sub')).addClass('active');
      });
    });
  });
}).call(this);
