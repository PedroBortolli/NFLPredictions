#require 'rest-client'
module PagesHelper
	def call_api (url)
		timestamp = Time.now.in_time_zone.to_i
		url = url+"?timestamp="+timestamp.to_s
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

	def user_exists (username)
		user_database = User.all
		for user in user_database
			if user.username == username
				return true
			end
		end
		return false
	end

	def picks_result (username)
		schedule = load_schedule
		picks = load_user_picks(username)
		result = Array.new
		result.push([])
		for week in 1..17
			aux = Hash.new
			result.push(aux)
			for game in schedule[week.to_s]
				if picks.key?(game["gameId"]) and game["winner"] != "" and game["winner"] != "TIE"
					if picks[game["gameId"]] == game["winner"]
						result[week].store(game["gameId"], true)
					else
						result[week].store(game["gameId"], false)
					end
				end
			end
		end
		return result
	end

	def count_result (username, result)
		week_score = Array.new
		week_score.push([])
		ok = 0
		wrong = 0
		for week in 1..17
			ok_week = 0
			wrong_week = 0
			result[week].each do |id, res|
				if res == true
					ok_week += 1
				else
					wrong_week += 1
				end
			end
			week_score.push([ok_week, wrong_week])
			ok += ok_week
			wrong += wrong_week
		end
		overall_score = [ok, wrong]
		return week_score, overall_score
	end

	def left_to_close(gameDay, gameTimeET)
		date = gameDay.split("-")
		day = Time.utc(date[0].to_i,date[1].to_i,date[2].to_i)
		timeest = Time.now.in_time_zone
		timeutc = Time.now.in_time_zone.utc
		time_difference_in_seconds = timeutc.utc_offset - timeest.utc_offset
		gameTime = day.to_i + time_difference_in_seconds
		tme = gameTimeET.split(" ")
		hm = tme[0].split(":")
		add = hm[0].to_i*3600 + hm[1].to_i*60
		if tme[1] == "PM"
			add += 12*3600
		end
		gameTime = gameTime + add
		timeNow = timeutc.to_i
		return gameTime-timeNow
	end

	def can_pick (gameDay, gameTimeET)
		if left_to_close(gameDay, gameTimeET) < 30*60
			return false
		end
		return true
	end
end