module Admin
  class SymptomaticsController < Admin::BaseController
    crudify :symptomatic, :title_attribute => 'condition', :xhr_paging => true
  end
end
