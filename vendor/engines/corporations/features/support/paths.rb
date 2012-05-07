module NavigationHelpers
  module Refinery
    module Corporations
      def path_to(page_name)
        case page_name
        when /the list of corporations/
          admin_corporations_path

         when /the new corporation form/
          new_admin_corporation_path
        else
          nil
        end
      end
    end
  end
end
