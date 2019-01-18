class ApplicationMailer < ActionMailer::Base
  #The application mailer with a new default from address.
  default from: "vizhooelmenu@gmail.com"
  layout 'mailer'
end
