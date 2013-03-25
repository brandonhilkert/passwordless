class LoginMailer < ActionMailer::Base
  default from: "Baby <hi@#{ENV["DOMAIN"]}.com>"

  def code(email, id, code)
    @email = email
    @id = id
    @code = code
    mail to: email, subject: "#{ENV["DOMAIN"]} log in code"
  end
end
