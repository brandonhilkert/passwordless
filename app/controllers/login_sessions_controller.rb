class LoginSessionsController < ApplicationController
  def index
  end

  def create
    email = params[:login_session][:email]

    if email =~ LoginSession::EMAIL_REGEX
      login_session = LoginSession.create_from_email(email)
      LoginMailer.code(email, login_session.id, login_session.code).deliver

      redirect_to root_url, notice: I18n.t(:login_email_code)
    else
      flash.now[:notice] = I18n.t(:login_bad_email)
      render :index
    end
  end

  def code
    id = params[:id]
    code = params[:code]
    ip = request.remote_ip
    user_agent = request.env["HTTP_USER_AGENT"]

    login_session = LoginSession.find_by_id(id)

    if login_session.blank?
      flash[:notice] = I18n.t(:login_invalid_link)

    elsif login_session.activated? || login_session.terminated?
      flash[:notice] = I18n.t(:login_link_already_used)

    elsif login_session.expired?
      flash[:notice] = I18n.t(:login_link_expired)

    elsif login_session.activate_session!(code, ip, user_agent)
      user = User.where(email: login_session.email).first_or_create
      login(login_session, user)
      flash[:notice] = I18n.t(:login_success)

    else
      flash[:notice] = I18n.t(:login_link_error)
    end

    redirect_to root_url
  end

  def destroy
    logout
    redirect_to root_url
  end
end
