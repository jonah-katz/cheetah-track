class SlackInterfaceController < ApplicationController

	def index
		puts "WOW" << params.inspect
		render json:{"text" => "WOW" << params.inspect}
	end

	def authorize_slack 
		redirect_to "https://slack.com/oauth/authorize?client_id=<REMOVED>&scope=chat:write:bot"
	end

	def oauth
		redirect_to "https://slack.com/api/oauth.access?code=#{params[:code]}&client_id=<REMOVED>&client_secret=<REMOVED>"
	end
end