ActionMailer::Base.smtp_settings = {
  :user_name => "username",
  :password => "password",
  :domain => "domain.com",
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options = {
  host: ENV["DOMAIN"]
}

if ENV["EMAIL_OVERRIDE"]
  class OverrideMailReciptient
    def self.delivering_email(mail)
      mail.to = ENV["EMAIL_OVERRIDE"]
    end
  end
  ActionMailer::Base.register_interceptor(OverrideMailReciptient)
end
