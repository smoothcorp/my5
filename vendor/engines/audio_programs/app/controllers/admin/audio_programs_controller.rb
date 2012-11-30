module Admin
  class AudioProgramsController < Admin::BaseController

    crudify :audio_program, :xhr_paging => true

  end
end
