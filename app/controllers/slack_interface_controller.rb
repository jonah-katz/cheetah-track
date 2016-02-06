class SlackInterfaceController < ApplicationController

	def index
		render json:{"text" => SlackCommandParser.new.command(params)}
	end

end