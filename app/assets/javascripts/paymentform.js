DP.PaymentForm = function() {
  this.setup();
};

DP.PaymentForm.prototype = {
  setup: function() {
    $("#payment-form").submit(_.bind(function(event) {
      // disable the submit button to prevent repeated clicks
      var $button = $('.submit-button');
      $button.attr("disabled", "disabled").addClass('active');

      Stripe.createToken({
        number: $('.card-number').val(),
        cvc: $('.card-cvc').val(),
        exp_month: $('.card-expiry-month').val(),
        exp_year: $('.card-expiry-year').val()
      }, _.bind(this.stripeResponseHandler, this));

      return false; // submit from callback
    }, this));
  },

  stripeResponseHandler: function(status, response) {
    if (response.error) {
      $('.submit-button').removeAttr("disabled").removeClass('active');
      $(".payment-errors").html(response.error.message);
    } else {
      var form$ = $("#payment-form");
      var token = response['id'];
      form$.append("<input type='hidden' name='donation[stripe_token]' value='" + token + "' />");
      this.submitForm();
    }
  },

  submitForm: function() {
    var $form = $("#payment-form");
    var data = $form.serialize();
    var post_url = '/api/donations'

    $.post(post_url, data, function(data) {
      DP.realtime.reloadDonations();
    });
  }
};
