class PagesController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :authenticate_user!, :except => [:index, :about, :view, :result]
	include PagesHelper

	def predictions
		@schedule = load_schedule
		@games_picked = load_user_picks (current_user.username)
	end

	def view
		@username = params[:user]
		@schedule = load_schedule
		@games_picked = load_user_picks (@username)
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
			data.delete
		end
	end

	def update
		winner = params[:gameWinner].to_s
		gameId = params[:gameId].to_s
		prediction = search_for_game(current_user.username, gameId)
		puts(prediction)
		if prediction == nil
			prediction = Prediction.new
			prediction.user = current_user.username
			prediction.gameId = gameId
			prediction.winner = winner
		else
			prediction.gameId = gameId
			prediction.winner = winner
		end
		prediction.save
	end
end