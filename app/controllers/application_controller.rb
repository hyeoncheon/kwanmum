class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :login_required

  private
  def current_user
    @current_user ||= User.find_by_id(session[:user]) if session[:user]
  end
  helper_method :current_user

  def login_required
    unless current_user
      session[:redirect_uri] = env['REQUEST_URI']
      flash[:error] = 'Login required!'
      redirect_to signin_path
    end
  end

  def activity_log(cat, level, message, how=nil, what=nil, why=nil, tags=nil)
    now = Time.now
    where = env['HTTP_X_FORWARDED_FOR']
    process = env['HTTP_USER_AGENT']
    if current_user
      who = current_user.name
      current_user.logs.create(
        category: cat, level: level, time: now, service: :kwanmun,
        process: process, message: message, hostname: where,
        actor: who, action: how, target: what, reason: why, tag: tags)
    else
      sys = Server.find_by_address('127.0.0.1')
      sys.logs.create(
        category: cat, level: :error, time: now, service: :kwanmun,
        process: process, message: message, hostname: where,
        actor: :bug, action: how, target: what, reason: why, tag: tags)
    end
  end
end
# vim: set ts=2 sw=2 expandtab:
