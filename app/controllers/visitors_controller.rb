class VisitorsController < ApplicationController
	def index
		render 'index'
	end

	def privacy
	end
	
	def support

	end

	def email_support
		begin
			Support.create(email: params[:email], message: params[:message])
		rescue
		end
	end
	
end
