class ApplicationController < ActionController::Base
  include Pundit
  # prevent CSRF attack by raising an exception.
  # for apis, you may want to use :null_session instead
  protect_from_forgery with: :exception

end
