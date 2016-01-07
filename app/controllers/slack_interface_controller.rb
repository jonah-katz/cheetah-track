class SlackInterfaceController < ApplicationController

	def index
		render json:{"text" => SlackCommandParser.new.command(params)}
	end

	def authorize_slack 
		redirect_to "https://slack.com/oauth/authorize?client_id=#{ENV['SLACK_CLIENT_ID']}&scope=chat:write:bot"
	end

	def oauth
		redirect_to "https://slack.com/api/oauth.access?code=#{params[:code]}&client_id=#{ENV['SLACK_CLIENT_ID']}&client_secret=#{ENV['SLACK_CLIENT_SECRET']}"
	end
end