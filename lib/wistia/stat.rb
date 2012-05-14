module Wistia
	class Stat

		def initialize(media_id, stats={})
			@media_id = media_id
			@stats = stats
		end

		def page_loads
			0 if @stats["pageLoads"].nil?
			@stats["pageLoads"]
		end

		def visitors
			0 if @stats["visitors"].nil?
			@stats["visitors"]
		end

		def plays
			0 if @stats["plays"].nil?
			@stats["plays"]
		end

		def average_percent_watched
			"0 %" if @stats["averagePercentWatched"].nil?
			"#{@stats["averagePercentWatched"]} %"
		end

		def percent_of_visitors_clicking_play
			"0 %" if @stats["percentOfVisitorsClickingPlay"].nil?
			"#{@stats["percentOfVisitorsClickingPlay"]} %"
		end

	end
end