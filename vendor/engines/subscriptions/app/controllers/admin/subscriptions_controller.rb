module Admin
  class SubscriptionsController < Admin::BaseController

    crudify :subscription, :xhr_paging => true

  end
end
