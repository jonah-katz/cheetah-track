class SlackInterfaceController < ApplicationController	
	include HTTParty


	def index
		render json:{"text" => SlackCommandParser.new.command(params)}
	end

	def setup 

		# POST form submit
		if params.has_key?(:slack_user_id) && params.has_key?(:toggl_api_token)
			account = TogglAccount.find_or_create_by(slack_user_id: params[:slack_user_id])
			account.api_token = params[:toggl_api_token]
			account.save
			redirect_to '/?setup_done=true'
			return
		end
		@slack_user_id = params.has_key?(:info) ? params[:info] : false
		redirect_to '/' unless @slack_user_id
	end

	def oauth
  		url = "https://slack.com/api/oauth.access?code=#{params[:code]}&client_id=#{ENV['SLACK_CLIENT_ID']}&client_secret=#{ENV['SLACK_CLIENT_SECRET']}"
  		res = self.class.get url
  		puts "TEST " << res.inspect << ' - ' << url
		redirect_to '/?added_to_slack=true'
  	end
end