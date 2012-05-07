/* DO NOT MODIFY. This file was compiled Wed, 12 Oct 2011 04:59:38 GMT from
 * /Users/chrishexton/Desktop/workspaces/rails/my5/app/coffeescripts/pages/contact.coffee
 */

(function() {
  $(document).ready(function() {
    return $('#email_submit').click(function(event) {
      var data;
      event.preventDefault();
      data = $('#new_email').serialize();
      $('.error').each(function(e) {
        return $(this).remove();
      });
      $('#email_submit').text('Sending...');
      return $.post('/emails', data, function(data) {
        switch (data) {
          case "true":
            return $('#contact_form').text("Thanks for getting in touch! We'll write back soon.");
          case "false":
            $('#email_submit').text('Submit');
            return alert('Something went wrong, please try again.');
          default:
            data = $.parseJSON(data);
            return $.each(data, function(key, value) {
              $('#email_' + key + '_input').append($('<p></p>').addClass('error').text("" + value));
              return $('#email_submit').text('Submit');
            });
        }
      });
    });
  });
}).call(this);
