require 'net/http'


class SlackInterfaceController < ApplicationController

	def index
		render json:{"text" => SlackCommandParser.new.command(params)}
	end

	def oauth
  		url =  "https://slack.com/api/oauth.access?code=#{params[:code]}&client_id=#{ENV['SLACK_CLIENT_ID']}&client_secret=#{ENV['SLACK_CLIENT_SECRET']}"
		url = URI.parse(url)
		req = Net::HTTP::Get.new(url.to_s)
		res = Net::HTTP.start(url.host, url.port) {|http|
			redirect_to '/?added_to_slack=true'
		}
  	end
end