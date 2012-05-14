module Wistia
	class Media
		include HTTParty
		format :json

		API_KEY = "626e8255cec9c9c6d167bfc1e3d03dba21863d25"
		API_URI = "https://api.wistia.com/v1"
		USER_NAME = "api"

		attr_accessor :embed_code

		def initialize(id, embed_code)
			@id, @embed_code = id, embed_code
		end

		def stat
			response = HTTParty.get(API_URI + "/medias/#{@id}/stats.json", Wistia::Media.auth)
			Wistia::Stat.new(response["id"], response["stats"])
		end

		def self.find_by_id(media_id)
			response = get(API_URI + "/medias/#{media_id}.json", auth)
			Wistia::Media.new(response["id"], response["embedCode"])
		end

		private
		def self.auth
			{:basic_auth => {:username => USER_NAME, :password => API_KEY}}
		end

	end
end