class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def requires_authentication!
    redirect_to login_sessions_url, notice: I18n.t(:requires_authentication) unless current_user
  end

  def login(login_session, user)
    session[:login_session_id] = login_session.id if login_session
    session[:user_id] = user.id if user
  end

  def logout
    current_login_session.kill!
    session[:login_session_id] = nil
    session[:user_id] = nil
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def current_login_session
    @current_login_session ||= LoginSession.find_by_id(session[:login_session_id]) if session[:login_session_id]
  end
end
