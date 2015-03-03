class SessionsController < ApplicationController
  def create
    omniauth = request.env['omniauth.auth']
    ai = omniauth[:info].clone
    ai[:uid] = omniauth[:uid]
    ai[:omniauth] = omniauth
    logger.debug("DEBUG info: --#{ai.to_xml}--")

    # for test purpose. edit below for real action.
    render :xml => ai.to_xml
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
