class ErrorMailer < ApplicationMailer
  default from: 'Sam Ruby <depot@example.com>'
  default to: 'Sam Ruby <depot@example.com>'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.error_mailer.failed.subject
  #
  def error(message)
    @message = message

    mail subject: 'Pragmatic Store Error'
  end
end
