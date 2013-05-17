$(document).ready(function() {
    if (!window.DP.Round.closed) {
        window.DP.realtime = new window.DP.Realtime();
        window.DP.paymentform = new window.DP.PaymentForm();
    }
});
