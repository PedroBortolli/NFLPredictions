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

	def load_schedule
		url = "https://www.fantasyfootballnerd.com/service/schedule/json/56rzxuc2a53b/"
		schedule = call_api(url)["Schedule"]
		parsed_schedule = Hash.new{|h,k| h[k] = Array.new}
		for game in schedule
			parsed_schedule[game["gameWeek"]].push(game)
		end
		return parsed_schedule
	end

	def load_user_picks (username)
		url = "https://www.fantasyfootballnerd.com/service/weather/json/56rzxuc2a53b/"
		games_info = call_api(url)
		games_picked = Hash.new
		database = Prediction.all
		for data in database
			if data.user == username
				games_picked.store(data.gameId, data.winner) 
			end
		end
		return games_picked
	end
end