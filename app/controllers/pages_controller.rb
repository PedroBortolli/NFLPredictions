class PagesController < ApplicationController
	skip_before_action :verify_authenticity_token
	include PagesHelper

	def predictions
		url = "https://www.fantasyfootballnerd.com/service/schedule/json/56rzxuc2a53b/"
		schedule = call_api(url)["Schedule"]
		parsed_schedule = Hash.new{|h,k| h[k] = Array.new}

		for game in schedule
			parsed_schedule[game["gameWeek"]].push(game)
		end

		@@current_user = params[:username]
		@user = @@current_user
		@games_picked = Hash.new
		database = Prediction.all

		for data in database
			if data.user == @@current_user
				@games_picked.store(data.gameId, data.winner) 
			end
		end

		@content = parsed_schedule
	end

	def index
	end

	def about
		render html: "Alou"
	end

	def result
		database = Prediction.all
		for data in database
			puts("(" + data.user.to_s + ")  =>  " + data.winner.to_s + " " + data.gameId.to_s)
			#data.delete
		end
	end

	def update
		winner = params[:gameWinner].to_s
		gameId = params[:gameId].to_s
		prediction = search_for_game(@@current_user, gameId)
		puts(@@current_user)
		puts(prediction)
		if prediction == nil
			prediction = Prediction.new
			prediction.user = @@current_user
			prediction.gameId = gameId
			prediction.winner = winner
		else
			prediction.gameId = gameId
			prediction.winner = winner
		end
		prediction.save
	end
end