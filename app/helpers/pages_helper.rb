#require 'rest-client'
module PagesHelper
	def call_api (url)
		response_from_api = RestClient.get(url)
		parsed_json = JSON.parse(response_from_api)
		return parsed_json
	end
end