json.set! :round do
  json.partial! 'api/rounds/round', round: @round
end

json.set! :donations_template, @donations
json.set! :payment_info_template, @payment_info
