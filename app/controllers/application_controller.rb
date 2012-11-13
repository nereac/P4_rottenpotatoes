
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_current_user, :except => [:login]
  protected # prevents method from being invoked by a route
  def set_current_user
    # we exploit the fact that find_by_id(nil) returns nil
    @current_user ||= Moviegoer.find_by_id(session[:user_id])
  end
  def login
    redirect_to '/login' and return unless @current_user
  end
end
