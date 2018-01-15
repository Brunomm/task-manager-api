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

	def update
		user = User.find_by( id: params[:id] )
		if user
			if user.update( user_params )
				render json: user, status: 200
			else
				render json: {errors: user.errors}, status: 422
			end
		else
			render status: 404
		end
	end

	def destroy
		user = User.find_by( id: params[:id] )
		if user.destroy
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
