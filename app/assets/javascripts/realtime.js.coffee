class window.DP.Realtime
  init: ->
    if typeof Pusher == 'function'
      @pusher = new Pusher(DP.PUSHER_KEY)
      @channel = @pusher.subscribe DP.Round.url
      @channel.bind('new:charge', _.bind(@newCharge, this))
      console.log(["Subscribing to real-time", @pusher, @channel])

  newCharge: ->
    console.log(["REAL-TIME: New Charge", arguments])
    @reloadDonations()

  reloadDonations: (data)->
    if !data
      $.get('/round_status/' + DP.Round.url, {}, @renderDonations)
    else
      @renderDonations(data)

  renderDonations: (data)->
    console.log(["Round status", data])
    $('.donations').html(data.donations_template)
    $('.payment-info').html(data.payment_info_template)
    @secondsLeft = data.seconds_left
    if data.closed
      window.location.href = window.location.href

  renderTimer: ->
    if @secondsLeft <= 0
      window.location.href = window.location.href

    $timer = $('.timer')
    minutes = Math.floor(@secondsLeft / 60)
    seconds = @secondsLeft % 60
    if seconds <= 9
      seconds = "0" + seconds
    $timer.html(minutes + ":" + seconds + " <span>time left</span>")
    @secondsLeft -= 1
