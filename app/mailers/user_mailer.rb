class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
    #mail(:to => "abunawose@avisualmenu.com", :subject => "User sign up", :body => "A new user signed up called #{@user.name}. Please reach out.")
  end

  def say_hello(params)
    contact_name    = params[:message_params]['name']
    contact_email   = params[:message_params]['email']
    contact_message = params[:message_params]['message']

    message = " Hi from #{contact_name} < #{contact_email} >.  My message is,  #{contact_message}"

    mail(:to => "abunawose@avisualmenu.com", :subject => "Say Hello", :body => message)
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  #Mailing the password reset link.
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
