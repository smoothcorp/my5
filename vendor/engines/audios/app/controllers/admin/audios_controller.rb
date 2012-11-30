module Admin
  class AudiosController < Admin::BaseController

    crudify :audio, :xhr_paging => true

  end
end
