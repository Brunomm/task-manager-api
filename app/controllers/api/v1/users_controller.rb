class Api::V1::UsersController < ApplicationController
	respond_to :json

	def show
		if user = User.find_by( id: params[:id] )
			respond_with user
		else
			render status: 404
		end
	end

	def create
		user = User.create( user_params )
		if user.persisted?
			render json: user, status: 201
		else
			render json: {errors: user.errors}, status: 422
		end
	end

private

	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end

end
