class ApplicationMailer < ActionMailer::Base
  #The application mailer with a new default from address.
  default from: "avisualmenu.com"
  layout 'mailer'
end
