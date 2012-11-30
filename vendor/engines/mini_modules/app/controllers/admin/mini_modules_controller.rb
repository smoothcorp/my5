module Admin
  class MiniModulesController < Admin::BaseController

    crudify :mini_module, :xhr_paging => true

    def destroy
      @mini_module = MiniModule.find(params[:id])
      if @mini_module.title.downcase == "simply stretch"
        flash[:alert] = "You cannot delete Simply Stretch.  Please ask the Administrator."
      else
        if @mini_module.destroy
          flash[:notice] = "Successfully deleted Mini Module."
        else
          flash[:alert] = "Uh-oh, something went wrong.  Please try again."
        end
      end
      redirect_to :action => "index"
    end
  end
end
