class SlackInterfaceController < ApplicationController	
	include HTTParty


	def index
		render json:{"text" => SlackCommandParser.new.command(params)}
	end

	def oauth
  		url = "https://slack.com/api/oauth.access?code=#{params[:code]}&client_id=#{ENV['SLACK_CLIENT_ID']}&client_secret=#{ENV['SLACK_CLIENT_SECRET']}"
  		res = self.class.get url
  		puts "TEST " << res.inspect << ' - ' << url
		redirect_to '/?added_to_slack=true'
  	end
end