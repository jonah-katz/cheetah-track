class SlackInterfaceController < ApplicationController

	def index
		puts "WOW" << params.inspect
		render json:{"text" => "WOW" << params.inspect}
	end
end