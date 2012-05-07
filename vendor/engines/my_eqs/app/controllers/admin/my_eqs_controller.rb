module Admin
  class MyEqsController < Admin::BaseController

    crudify :my_eq,
            :title_attribute => 'emotional_grouping', :xhr_paging => true

  end
end
