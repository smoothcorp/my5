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
                    $('#contact_form').text("Thanks for getting in touch! We'll write back soon.")
                when "false"
                    $('#email_submit').text('Submit')
                    alert('Something went wrong, please try again.')
                else
                    data = $.parseJSON(data)
                    $.each(data, (key, value) ->
                        $('#email_'+key+'_input').append($('<p></p>').addClass('error').text(""+value))
                        $('#email_submit').text('Submit')
                    )
        )