class AdminsController < ApplicationController
  layout "admin/layouts/application"
  before_action :ensure_admin!

  include SessionsHelper

  def ensure_admin!
    unless current_user&.admin?
      sign_out current_user

      redirect_to root_path
    end
  end
end
