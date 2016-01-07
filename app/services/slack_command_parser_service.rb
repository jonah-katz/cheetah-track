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
  	when 'stop'
  		stop
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
  		response << p['name'] << " - " << p['id'].to_s << "\n"
  	end
  	response
  end

  # /slackl status
  def status
  	te = toggle_request.get_current_time_entry
  	if !te
  		return "Timer isn't currently active."
  	end


  	return getStatusText(te);

  end

  def getStatusText(time_entry) 
  	return_t = {
  		if time_entry['duration'] > 0
  			return humanize time_entry['duration'] 
  		else 
  			return humanize Time.new.to_i + time_entry['duration']
  		end
  	}

  	project = false
  	if time_entry['pid']
  		project = getProjectById(time_entry['pid'])
  		return_t << ' - ' << project['name']
  	end
  	if time_entry['description']
  		return_t << ' - ' << time_entry['description']
  	end
  	return return_t
  end

  # /slackl start <project id> <optional description>
  def start
  	project_id = @text.split[1]
  	if !project_id
  		return "Sorry! I need a project id. ('/slackl start <project id> <optional description>')\n You can find one by using: '/slackl projects'"
  	end
  	project = getProjectById(project_id)
  	if project == false
  		return "Couldn't find a project with an id `" << project_id << "`" 
  	end

  	description = @text.split[2..-1].join(' ')
  	if toggle_request.start_time_entry({'pid' => project_id, 'description' => description})
  		return "Timers going!"
  	end

  	return "Something went wrong :/ Try again?"
  end

  def stop 
  	te = toggle_request.get_current_time_entry
  	if !te
  		return "Timer isn't currently active."
  	end

  	stop = toggle_request.stop_time_entry(te["id"])
  	"Timer stopped - " << getStatusText(stop)
  end

  def getProjectById pid
	toggle_request.my_projects.each do |p|
		if p['id'].to_s == pid.to_s
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
