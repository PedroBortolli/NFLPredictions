class PagesController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :authenticate_user!, :except => [:index, :about, :view, :result, :compare]
	include PagesHelper

	def predictions
		@schedule = load_schedule
		@games_picked = load_user_picks (current_user.username)
	end

	#esse metodo ta funcionando de boa, mesmo a cada acesso de /view ele pega o params[:user] corretamente
	def view
		@username = params[:user]
		if !user_exists(@username)
			redirect_to request.referrer, alert: "User does not exist"
		end
		@schedule = load_schedule
		@games_picked = load_user_picks (@username)
	end

	#esse metodo so funciona na primeira chamada dele, nos proximos ele nao consegue pegar os usernames corretamente
	def compare
		@username1 = params[:user1]
		@username2 = params[:user2]
		puts(@username1) #aqui tá printando "" nos outros acessos, porque o params[:userx] "some"
		puts(@username2) #aqui tá printando "" nos outros acessos, porque o params[:userx] "some"
		if !user_exists(@username1) or !user_exists(@username2)
			redirect_to request.referrer, notice: "User 1 and/or User 2 does not exist"
		end
		@schedule = load_schedule
		@games_picked_1 = load_user_picks(@username1)
		@games_picked_2 = load_user_picks(@username2)
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