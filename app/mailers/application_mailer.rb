class ApplicationMailer < ActionMailer::Base
  #The application mailer with a new default from address.
  default from: "abunawose@vizhooels.com"
  layout 'mailer'
end
