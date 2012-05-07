module Admin
  class VideosController < Admin::BaseController
    crudify(:video, :xhr_paging => true)

    def index
      unless searching?
        @videos = Video.order(set_order).paginate(:page => params[:page], :per_page => 30)
      else
        search_all_videos
        @videos = @videos.paginate(:page => params[:page], :per_page => 30)
      end

      render :partial => 'videos' if request.xhr?
    end

    def set_order
      if params["sort"] == "symptomatic"
        "COALESCE(symptomatic_id, ~0) DESC"
      elsif params["sort"] == "title"
        "title ASC"
      elsif params["sort"] == "mini_module"
        "COALESCE(mini_module_id, ~0) DESC"
      else
        "position ASC"
      end
    end

  end
end
