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
                    $('#sending_results').text("Thanks for getting in touch! We'll write back soon.")
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
                    $.each(data, (key, value) ->
                        $('#email_'+key+'_input').append($('<p></p>').addClass('error').text(""+value))
                        $('#email_submit').text('Send Contact Information')
                    )
        )
