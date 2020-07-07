class UsersController < ApplicationController
  before_action :load_user, :logged_in_user, only: %i(edit show update)
  before_action :correct_user, only: %i(edit update)

  def show
    @purchases = current_user.purchases
                             .paginate(page: params[:page],
                                 per_page: Settings.per_page_purchase)
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "profile.btn_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params
      .require(:user)
      .permit(:name, :phone_number, :email, :image, :address)
  end

  # current user != true rails warning
  def correct_user
    return if current_user? @user

    flash[:danger] = t "profile.user_correct"
    redirect_to root_url
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "profile.user_not_found"
    redirect_to root_url
  end
end
