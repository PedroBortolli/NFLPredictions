module Scrapper
	def teste_scrapper
		response = RestClient.get("http://www.nfl.com/schedules/2018/REG1")
		puts(response)
		return response
	end
end