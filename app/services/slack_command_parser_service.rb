class SlackCommandParser
	attr_accessor :slack_user_id,:text, :toggl_account,:api_instance
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
  	when 'status'
  		status
  	when 'start'
  		start
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
  	response = ''
	toggle_request.my_projects.each do |p|
  		response.push p['name'] << " - "<< p['id'] << "\n"
  	end
  	response
  end

  # /slackl status
  def status
  	te = toggle_request.get_current_time_entry
  	if !te
  		return "Timer isn't currently active."
  	end

  	return_t = humanize Time.new.to_i + te['duration']
  	project = false
  	if te['pid']
  		project = getProjectById(te['pid'])
  		return_t << ' - ' << project['name']
  	end
  	if te['description']
  		return_t << ' - ' << te['description']
  	end

  	return return_t;

  end

  # /slackl start <project id> <optional description>
  def start
  	project_id = @text.split[1]
  	project 
  	if !project_id
  		return "Couldn't find a project with an id `" << @project_id << "`" 
  	end

  	description = @text.split[1..-2].join(' ')
  	if toggle_request.start_time_entry({'pid' => project_id, 'description' => description})
  		return "Timers going!"
  	end

  	return "Something went wrong :/ Try again?"
  	

  end

  def getProjectById pid
	toggle_request.my_projects.each do |p|
		if p['id'] == pid
			return p
		end
	end
	return false
  end


  def toggle_request
  	if @api_instance
  		return @api_instance
  	end
  	@api_instance = TogglV8::API.new(@toggl_account.api_token)
  	return @api_instance
  end

  def get_toggle_account
  	ta = TogglAccount.where(slack_user_id: @slack_user_id)
  	if ta.length == 0
  		return "Run `slackl setup <TOGGL API TOKEN>` before proceeding."
  	else
  		@toggl_account = ta.first
  	end
  end

	def humanize secs
	  [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map{ |count, name|
	    if secs > 0
	      secs, n = secs.divmod(count)
	      "#{n.to_i} #{name}"
	    end
	  }.compact.reverse.join(' ')
	end

end
