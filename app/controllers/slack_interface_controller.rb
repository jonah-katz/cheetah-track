class SlackInterfaceController < ApplicationController

	def index
		render json:{"text" => SlackCommandParser.new.command(params)}
	end

	def authorize_slack 
		redirect_to "https://slack.com/oauth/authorize?client_id=<REMOVED>&scope=chat:write:bot"
	end

	def oauth
		redirect_to "https://slack.com/api/oauth.access?code=#{params[:code]}&client_id=<REMOVED>&client_secret=<REMOVED>"
	end
end