class ApplicationMailer < ActionMailer::Base
  #The application mailer with a new default from address.
  default from: "noreply@example.com"
  layout 'mailer'
end