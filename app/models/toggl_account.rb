class TogglAccount < ActiveRecord::Base

	def self.getApi user
    	TogglV8::API.new(user.api_token)
    end



end
