class window.DP.PaymentForm
  constructor: ->
    $("#payment-form").bind 'submit', (event)=>
      # disable the submit button to prevent repeated clicks
      $button = $('.submit-button')
      $button.attr("disabled", "disabled").addClass('active')

      Stripe.createToken({
        number: $('.card-number').val(),
        cvc: $('.card-cvc').val(),
        exp_month: $('.card-expiry-month').val(),
        exp_year: $('.card-expiry-year').val()
      }, _.bind(@stripeResponseHandler, this))

      return false # submit from callback

  stripeResponseHandler: (status, response)->
    if response.error
      $('.submit-button').removeAttr("disabled").removeClass('active')
      $(".payment-errors").html(response.error.message)
    else
      form$ = $("#payment-form")
      token = response['id']
      form$.append("<input type='hidden' name='stripeToken' value='" + token + "' />")
      this.submitForm()

  submitForm: ->
    $form = $("#payment-form")
    data = $form.serialize()

    $.post '/charge', data, (data)->
      DP.realtime.reloadDonations(data)
