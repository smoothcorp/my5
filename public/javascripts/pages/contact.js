/* DO NOT MODIFY. This file was compiled Wed, 22 Jan 2014 13:39:00 GMT from
 * /home/rsk/projects/my5/app/coffeescripts/pages/contact.coffee
 */


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
            $('#sending_results').text("Thanks for getting in touch! We'll write back soon.");
            return $('#email_submit').text('Send Contact Information');
          case "false":
            $('#email_submit').text('Send Contact Information');
            return alert('Something went wrong, please try again.');
          case 'captcha_error':
            $('#sending_results').text("* Wrong captcha symbols, please reenter.");
            $('#sending_results').addClass('.alert');
            return $('#email_submit').text('Send Contact Information');
          default:
            data = $.parseJSON(data);
            return $.each(data, function(key, value) {
              $('#email_' + key + '_input').append($('<p></p>').addClass('error').text("" + value));
              return $('#email_submit').text('Send Contact Information');
            });
        }
      });
    });
  });
