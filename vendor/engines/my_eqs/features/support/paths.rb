module NavigationHelpers
  module Refinery
    module MyEqs
      def path_to(page_name)
        case page_name
        when /the list of my_eqs/
          admin_my_eqs_path

         when /the new my_eq form/
          new_admin_my_eq_path
        else
          nil
        end
      end
    end
  end
end
