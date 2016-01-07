class SlackCommandParser
	attr_accessor :slack_user_id,:text, :toggl_account
  def command(params)
  	@text = params[:text]
  	@slack_user_id = params[:user_id]
  	parse
  end

  def parse
  	command = @text.partition(" ").first
  	if command != 'setup'
  		get_toggle_account
  	end
  	case command
  	when 'setup'
  		parse_setup_command
  	when 'projects'
  		projects
  	else
  		"I don't know that command. :("
  	end
  end

  # /slackl setup <TOGGL API TOKEN>
  def parse_setup_command
	if @text.partition(" ").length != 3
		return "Bad command. Format is: `/slackl setup <TOGGL API TOKEN>`"
	end

	token = @text.partition(" ")[2]

	account = TogglAccount.find_or_create_by(slack_user_id: @slack_user_id)
	account.api_token = token
	account.save
	"Done! The Toggl api token #{account.api_token} is now associated with your Slack account. You can change this at any time by using the same 'setup' command. \n\nTry typing `/slackl projects`"
  end

  def projects
  	toggle_request.my_projects.inspect
  end


  def toggle_request
  	TogglV8::API.new('#{@toggle_account.api_token}')
  end

  def get_toggle_account
  	ta = TogglAccount.where(slack_user_id: @slack_user_id)
  	if ta.length == 0
  		return "Run `slackl setup <TOGGL API TOKEN>` before proceeding."
  	else
  		@toggl_account = ta.first
  	end
  end

end
