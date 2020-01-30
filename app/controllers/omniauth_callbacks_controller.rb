class OmniauthCallbacksController < ApplicationController
  before_action :set_user_info

  def line
    user = User.authenticated_by_line(@user_info)
    sign_in user
    redirect_to :root
  end

  private

  def set_user_info
    @user_info = request.env['omniauth.auth']
  end
end
