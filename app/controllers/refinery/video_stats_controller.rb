class Refinery::VideoStatsController < ApplicationController
	before_filter :authenticate_user!
	layout 'admin'

	def index
		my_eq_step1s = MyEq.select("emotional_grouping, audio_step_1_wistia_video_id").where("audio_step_1_wistia_video_id is not null")
		my_eq_step5s = MyEq.select("emotional_grouping, audio_step_5_wistia_video_id").where("audio_step_5_wistia_video_id is not null")
		videos = Video.select("title, wistia_video_id").where("wistia_video_id is not null")
		audios = Audio.select("title, wistia_video_id").where("wistia_video_id is not null")
		@all_media = videos.collect{|v| [v.title, v.wistia_video_id]} +
			audios.collect{|a| [a.title, a.wistia_video_id]} +
			my_eq_step1s.collect{|mq| [mq.emotional_grouping, mq.audio_step_1_wistia_video_id] } +
			my_eq_step5s.collect{|mq| [mq.emotional_grouping, mq.audio_step_5_wistia_video_id] }

		if params[:media_id].present?
			@wistia_media = Wistia::Media.find_by_id(params[:media_id])
			@stat = @wistia_media.stat
		end
	end

end