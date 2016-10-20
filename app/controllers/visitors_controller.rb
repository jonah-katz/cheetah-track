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
			tracker = Staccato.tracker(ENV['GA_ID'])
			tracker.event(category: 'email_support', action: 'message', label: params[:message])

		rescue
		end
	end
	
end
