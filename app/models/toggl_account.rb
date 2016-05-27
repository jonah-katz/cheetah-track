class TogglAccount < ActiveRecord::Base

	def self.getApi user
    	TogglV8::API.new(user.api_token)
    end

  #   def self.test
	 #  	ta = TogglAccount.where(slack_user_id: '43432432')
		# @toggl_account = ta.first
		# pid = '5'

		# TogglV8::API.new(@toggl_account.api_token).my_projects.each do |p|
	 #    puts "LOOOOK " << p.inspect
		# 	if p['id'].to_s == pid.to_s
		# 		puts 'found by id'
		# 	end

		# 	if p['name'].downcase == pid.downcase
		# 		puts 'found by id'
		# 	end
		# end


  #   end



end
