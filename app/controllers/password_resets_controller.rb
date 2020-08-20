class PasswordResetsController < ApplicationController
  PASSWORD_PARAMS = %i(password password_confirmation).freeze

  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".email_sent"
      redirect_to root_url
    else
      flash.now[:error] = t ".send_fail"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, t(".cant_be_empty")
      render :edit
    else
      reset_password_handle
    end
  end

  private

  def reset_password_handle
    if @user.update user_params
      @user.update reset_digest: nil
      flash[:success] = t "password_resets.private.password_has_been_reset"
      redirect_to root_url
    else
      flash[:danger] = t "password_resets.private.can_not_reset_password"
      render :edit
    end
  end

  def user_params
    params.require(:user).permit PASSWORD_PARAMS
  end

  def get_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "password_resets.private.user_not_found"
    redirect_to root_url
  end

  def valid_user
    redirect_to root_url unless @user&.activated? && @user&.authenticated?(:reset, params[:id])
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "password_resets.private.password_reset_has_expired"
    redirect_to new_password_reset_url
  end
end
