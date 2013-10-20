class RoundMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.round_mailer.round_success.subject
  #
  def round_success
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
