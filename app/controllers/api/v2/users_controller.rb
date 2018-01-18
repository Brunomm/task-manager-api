class Api::V2::UsersController < ApplicationController
	before_action :authenticate_with_token!, only: [:update, :destroy]
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

	def update
		if current_user.update( user_params )
			render json: current_user, status: 200
		else
			render json: {errors: current_user.errors}, status: 422
		end
	end

	def destroy
		if current_user.destroy
			render status: 204
		else
			render status: 404
		end
	end

private

	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end

end
