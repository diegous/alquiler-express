class AdminMailer < ApplicationMailer
  def two_fa_email
    @admin = params[:admin]
    mail(to: @admin.email_address, subject: "Segundo factor de autenticación")
  end
end
