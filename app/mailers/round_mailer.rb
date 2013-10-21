class RoundMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.round_mailer.round_success.subject
  #
  def round_success(round, email)
    @greeting = "Hi"

    mail to: email
  end

  def round_failed(round, email)
    mail to: email, subject: "not enough people donated"
    @round = round
  end
end
