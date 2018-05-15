#require 'rest-client'
module PagesHelper
	def call_api (url)
		response_from_api = RestClient.get(url)
		parsed_json = JSON.parse(response_from_api)
		return parsed_json
	end

	def search_for_game (user, gameId)
		database = Prediction.all
		for data in database
			if data.user == user
				return data
			end
		end
		return nil
	end
end