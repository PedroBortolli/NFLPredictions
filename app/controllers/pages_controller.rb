class PagesController < ApplicationController
	skip_before_action :verify_authenticity_token
	include PagesHelper

	def test
		url = "https://www.fantasyfootballnerd.com/service/schedule/json/56rzxuc2a53b/"
		schedule = call_api(url)["Schedule"]
		parsed_schedule = Hash.new{|h,k| h[k] = Array.new}

		for game in schedule
			parsed_schedule[game["gameWeek"]].push(game)
		end

		#database = Prediction.all
		#for data in database

		#end

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
			puts("(" + data.user + ")  =>  " + data.winner + " " + data.gameId)
		end
	end

	def update
		winner = params[:gameWinner].to_s
		gameId = params[:gameId].to_s
		prediction = search_for_game("trololo", gameId)
		if prediction == nil
			prediction = Prediction.new
			prediction.user = "trololo"
			prediction.gameId = gameId
			prediction.winner = winner
		else
			prediction.gameId = gameId
			prediction.winner = winner
		end
		prediction.save
	end
end