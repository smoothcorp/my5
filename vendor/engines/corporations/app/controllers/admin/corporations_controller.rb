module Admin
  class CorporationsController < Admin::BaseController
    before_filter :authenticate_user!, :only => [:deactivate_corp]
  
    crudify :corporation,
            :title_attribute => 'name', :xhr_paging => true

    def deactivate_corp
      @corporation = Corporation.find(params[:id])
      if @corporation.active
        @success = true if @corporation.update_attribute(:active, false) 
      else
        @success = true if @corporation.update_attribute(:active, true) 
      end
    end
  end
end
