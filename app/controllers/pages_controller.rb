class PagesController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :authenticate_user!, :except => [:index, :about, :view, :result, :compare, :standings]
	include PagesHelper
	include Scrapper

	def predictions
		@schedule = load_schedule
		@games_picked = load_user_picks (current_user.username)
		@username = current_user.username
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
		@blabla = teste_scrapper
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

	def standings
		@username = params[:user]
		@schedule = load_schedule
		@games_picked = load_user_picks(@username)
		@wins = Hash.new
		@total = Hash.new
		for week in 1..17
			for game in @schedule[week.to_s]
				home = game["homeTeam"]
				away = game["awayTeam"]
				if !(@total.key?(home))
					@total.store(home, 0)
					@wins.store(home, 0)
				end
				if !(@total.key?(away))
					@total.store(away, 0)
					@wins.store(away, 0)
				end
				if @games_picked.key?(game["gameId"])
					picked = @games_picked[game["gameId"]]
					if @wins.key?(picked)
						@wins[picked] += 1
					end
					@total[home] += 1
					@total[away] += 1
				end
			end
		end
		@afc_east = [['NE', @wins['NE']], ['NYJ', @wins['NYJ']], ['BUF', @wins['BUF']], ['MIA', @wins['BUF']]]
		@afc_east = @afc_east.sort { |a, b| b[1] <=> a[1] }
		@afc_north = [['PIT', @wins['PIT']], ['CIN', @wins['CIN']], ['BAL', @wins['BAL']], ['CLE', @wins['CLE']]]
		@afc_north = @afc_north.sort { |a, b| b[1] <=> a[1] }
		@afc_west = [['DEN', @wins['DEN']], ['LAC', @wins['LAC']], ['OAK', @wins['OAK']], ['KC', @wins['OAK']]]
		@afc_west = @afc_west.sort { |a, b| b[1] <=> a[1] }
		@afc_south = [['IND', @wins['IND']], ['HOU', @wins['HOU']], ['JAC', @wins['JAC']], ['TEN', @wins['TEN']]]
		@afc_south = @afc_south.sort { |a, b| b[1] <=> a[1] }
		@nfc_east = [['DAL', @wins['DAL']], ['WAS', @wins['WAS']], ['NYG', @wins['NYG']], ['PHI', @wins['PHI']]]
		@nfc_east = @nfc_east.sort { |a, b| b[1] <=> a[1] }
		@nfc_north = [['GB', @wins['GB']], ['MIN', @wins['MIN']], ['CHI', @wins['CHI']], ['DET', @wins['DET']]]
		@nfc_north = @nfc_north.sort { |a, b| b[1] <=> a[1] }
		@nfc_west = [['SEA', @wins['SEA']], ['ARI', @wins['ARI']], ['SF', @wins['SF']], ['LAR', @wins['LAR']]]
		@nfc_west = @nfc_west.sort { |a, b| b[1] <=> a[1] }
		@nfc_south = [['CAR', @wins['CAR']], ['TB', @wins['TB']], ['NO', @wins['NO']], ['ATL', @wins['ATL']]]
		@nfc_south = @nfc_south.sort { |a, b| b[1] <=> a[1] }
	end
end