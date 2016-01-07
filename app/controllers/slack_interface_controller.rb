class SlackInterfaceController < ApplicationController

	def index
		puts "WOW" << params.inspect
		render json:{"text" => "WOW" << params.inspect}
	end

	def oauth 
		redirect_to "https://slack.com/oauth/authorize?client_id=17965490070.17965037873&scope=chat:write:bot"
	end
end