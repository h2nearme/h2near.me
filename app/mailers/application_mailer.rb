class ApplicationMailer < ActionMailer::Base
  default from: "postmaster@mail.h2near.me"
  layout "mailer"
end
