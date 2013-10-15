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
    if (data.closed) {
      window.location.href = window.location.href;
    }
  },

  renderTimer: function() {
    var minutes, seconds;
    var $timer;
    var seconds_left = (new Date(DP.Round.expire_time) - new Date()) / 1000;

    if (seconds_left <= 0) {
      window.location.href = window.location.href;
    }

    $timer = $('.timer');
    minutes = Math.floor(seconds_left / 60);
    seconds = Math.round(seconds_left % 60);
    if (seconds <= 9) seconds = "0" + seconds;
    $timer.html(minutes + ":" + seconds + " <span>time left</span>");
  }
};
