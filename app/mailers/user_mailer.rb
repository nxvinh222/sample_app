class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("user_mailer.account_activation.mailer.account_activation")
  end

  def password_reset
    @greeting = "Hi"
    mail to: user.email, subject: t("user_mailer.account_activation.mailer.reset")
  end
end
