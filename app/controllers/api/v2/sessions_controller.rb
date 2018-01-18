class Api::V2::SessionsController < ApplicationController
  def create
    user = User.find_by(email: session_params[:email])
    if user && user.valid_password?(session_params[:password])
      user.generate_authentication_token!
      sign_in user, store: false
      render json: {auth_token:  user.auth_token}, status: 200
    else
      render json: {errors:  ['Invalid email or password']}, status: 401
    end
  end

  def destroy
    if user = User.find_by(auth_token: params[:id])
      user.generate_authentication_token!
      user.save
      head 204
    end
  end

private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
