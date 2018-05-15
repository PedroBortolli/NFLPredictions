#require 'rest-client'
module PagesHelper
	def call_api (url)
		response_from_api = RestClient.get(url)
		parsed_json = JSON.parse(response_from_api)
		return parsed_json
	end

	def search_for_game (current_user, gameId)
		database = Prediction.all
		for data in database
			if data.user == current_user
				if data.gameId == gameId
					return data
				end
			end
		end
		return nil
	end
end