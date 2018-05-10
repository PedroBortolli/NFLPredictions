class PagesController < ApplicationController
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
		@q = params[:param1].to_s
	end
end
