DP.RealTime = function() {
    this.setup();
}

DP.RealTime.prototype = {
  setup: function() {
    if (typeof Pusher == 'function') {
      this.pusher = new Pusher(DP.PUSHER_KEY);
      this.channel = this.pusher.subscribe(DP.Round.url);
      this.channel.bind('new:charge', _.bind(this.newCharge, this));
      console.log(["Subscribing to real-time", this.pusher, this.channel]);
    }

    this.seconds_left = DP.Round.seconds_left;
    this.reloader = setInterval(_.bind(this.reloadDonations, this), 1000*60);
    this.timer = setInterval(_.bind(this.renderTimer, this), 1000*1);
  },

  newCharge: function() {
    console.log(["REAL-TIME: New Charge", arguments]);
    this.reloadDonations();
  },

  reloadDonations: function() {
    $.get('/api/rounds/' + DP.Round.url, {}, this.renderDonations);
  },

  renderDonations: function(data) {
    console.log(["Round status", data]);
    $('.donations').html(data.donations_template);
    $('.payment-info').html(data.payment_info_template);
    this.seconds_left = data.seconds_left;
    if (data.closed) {
      window.location.href = window.location.href;
    }
  },

  renderTimer: function() {
    if (this.seconds_left <= 0) {
      window.location.href = window.location.href;
    }

    var $timer = $('.timer');
    var minutes = Math.floor(this.seconds_left / 60);
    var seconds = this.seconds_left % 60;
    if (seconds <= 9) seconds = "0" + seconds;
    $timer.html(minutes + ":" + seconds + " <span>time left</span>");
    this.seconds_left -= 1;
  }
};
