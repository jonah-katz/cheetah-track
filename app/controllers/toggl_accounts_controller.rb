class TogglAccountsController < ApplicationController
	def create
		ta = TogglAccount.new(slack_user_id: params[:slack_user_id], api_token: params[:toggl_token],user_id: current_user.id)
		if ta.save
			redirect_to root_path
		end
	end

	def destroy
		if TogglAccount.find(params[:toggl_account_id]).destroy
			redirect_to root_path
		end
	end

end
