class VisitorsController < ApplicationController
	def index
		if user_signed_in?
			@toggls = TogglAccount.where(user_id: current_user.id)
			render 'authenticated'
		else
			render 'index'
		end
	end
end
