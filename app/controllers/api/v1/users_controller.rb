class Api::V1::UsersController < ApplicationController
	respond_to :json

	def show
		if user = User.find_by( id: params[:id] )
			respond_with user
		else
			render status: 404
		end
	end
end
