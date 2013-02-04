var DP = {
	RealTime: function() {
    this.setup();
	},
};

DP.RealTime.prototype = {
    setup: function() {
        this.pusher = new Pusher(DP.PUSHER_KEY);
        this.channel = this.pusher.subscribe(DP.Round.url);
        this.channel.bind('new:charge', _.bind(this.newCharge, this));
        console.log(["Subscribing to real-time", this.pusher, this.channel]);

        this.secondsLeft = DP.Round.secondsLeft;
        this.reloader = setInterval(_.bind(this.reloadDonations, this), 1000*60);
        this.timer = setInterval(_.bind(this.renderTimer, this), 1000*1);
    },

    newCharge: function() {
        console.log(["REAL-TIME: New Charge", arguments]);
        this.reloadDonations();
    },

    reloadDonations: function(data) {
        if (!data) {
            $.get('/round_status/' + DP.Round.url, {}, this.renderDonations);
        } else {
            this.renderDonations(data);
        }
    },

    renderDonations: function(data) {
        console.log(["Round status", data]);
        $('.donations').html(data.donations_template);
        $('.payment-info').html(data.payment_info_template);
        this.secondsLeft = data.seconds_left;
        if (data.closed) {
            window.location.href = window.location.href;
        }
    },

    renderTimer: function() {
	if (this.secondsLeft <= 0) {
            window.location.href = window.location.href;
        }

        var $timer = $('.timer');
        var minutes = Math.floor(this.secondsLeft / 60);
        var seconds = this.secondsLeft % 60;
        if (seconds <= 9) seconds = "0" + seconds;
        $timer.html(minutes + ":" + seconds + " <span>time left</span>");
        this.secondsLeft -= 1;
    }

};

$(document).ready(function() {
    if (!DP.Round.closed) {
        DP.realtime = new DP.RealTime();
        DP.paymentform = new DP.PaymentForm();
    }
});

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
            form$.append("<input type='hidden' name='stripeToken' value='" + token + "' />");
            this.submitForm();
        }
    },

    submitForm: function() {
        var $form = $("#payment-form");
        var data = $form.serialize();

        $.post('/charge', data, function(data) {
            DP.realtime.reloadDonations(data);
        });
    }
};
