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

		@content = parsed_schedule
	end

	def about
		render html: "Alou"
	end

	def result
	end

	def update
		puts("Eaeeeeeeeeeeeeeee")
		picks = Hash.new
		winner = params[:gameWinner].to_s
		gameId = params[:gameId].to_s
		puts(winner, gameId)
	end
end