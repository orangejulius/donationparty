json.set! :round do
  json.set! :expire_time, @round.expire_time
  json.set! :seconds_left, @round.seconds_left
  json.set! :closed, @round.closed
end

json.set! :donations_template, @donations
json.set! :payment_info_template, @payment_info
