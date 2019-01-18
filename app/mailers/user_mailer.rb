class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def say_hello(params)
    contact_name    = params[:message_params]['name']
    contact_email   = params[:message_params]['email']
    contact_message = params[:message_params]['message']

    mail(to: 'vizhooelmenu@gmail.com', subject: 'SAY HELLO') do |format|
      format.text { render plain: contact_message }
      format.html { render html: "<h1>Hello VIZHO͞OƏLS!</h1><br><p>My name is #{contact_name} and my email is #{contact_email}. My Message is: #{contact_message}</p>".html_safe }
    end
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
