class SessionsController < ApplicationController
  def create
    omniauth = request.env['omniauth.auth']
    ai = omniauth[:info].clone
    ai[:uid] = omniauth[:uid]
    ai[:omniauth] = omniauth
    logger.debug("DEBUG info: --#{ai.to_xml}--")

    #render :xml => ai.to_xml
    unless @user = User.find_by_siso_uid(ai[:uid])
      @user = User.create(siso_uid: ai[:uid], siso_gid: ai[:gid],
                          siso_active: ai[:active],
                          name: ai[:name], mail: ai[:email], image: ai[:image])
      flash[:notice] = "New user for #{@user.mail} registered!"
    else
      # update user informations from siso.
      @user.siso_gid = ai[:gid]
      @user.siso_active = ai[:active]
      @user.name = ai[:name]
      @user.mail = ai[:email]
      @user.image = ai[:image]
      @user.save
      flash[:notice] = "welcome #{@user.name}!"
    end
    session[:user] = @user.id
    session[:name] = @user.name
    session[:mail] = @user.mail

    logger.debug("DEBUG cookie_origin: #{cookies[:siso_oauth_origin]}")
    next_path = cookies[:siso_oauth_origin] || root_path
    cookies.delete :siso_oauth_origin
    redirect_to next_path
  end

  def failure
    flash[:error] = request.parameters['message']
    redirect_to root_path
  end

  def signout
    if current_user
      session[:user] = nil
      session.delete :user
      flash[:notice] = 'successfully signed out!'
    end
    redirect_to root_path
  end
end
# vim: set ts=2 sw=2 expandtab:
