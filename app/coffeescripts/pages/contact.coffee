$(document).ready ->
    $('#email_submit').click (event) ->
        event.preventDefault()
        data = $('#new_email').serialize()
        $('.error').each (e) ->
            $(this).remove()
        $('#email_submit').text('Sending...')
        $.post('/emails', data, (data) ->
            switch data
                when "true"
                    $('#sending_results').text("Thanks for getting in touch. We will be in contact with you soon.")
                    $('#email_submit').text('Send Contact Information')
                when "false"
                    $('#email_submit').text('Send Contact Information')
                    alert('Something went wrong, please try again.')
                when 'captcha_error'
                  $('#sending_results').text("* Wrong captcha symbols, please reenter.")
                  $('#sending_results').addClass('.alert')
                  $('#email_submit').text('Send Contact Information')

                else
                    data = $.parseJSON(data)
                    errors = data.errors
                    $.each(errors, (key, value) ->
                        $('#email_'+key+'_input').append($('<p></p>').addClass('error').text(""+value))
                        $('#email_submit').text('Send Contact Information')
                    )
        )

