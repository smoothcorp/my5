module NavigationHelpers
  module Refinery
    module Subscriptions
      def path_to(page_name)
        case page_name
        when /the list of subscriptions/
          admin_subscriptions_path

         when /the new subscription form/
          new_admin_subscription_path
        else
          nil
        end
      end
    end
  end
end
