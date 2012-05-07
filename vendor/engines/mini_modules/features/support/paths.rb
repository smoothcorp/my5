module NavigationHelpers
  module Refinery
    module MiniModules
      def path_to(page_name)
        case page_name
        when /the list of mini_modules/
          admin_mini_modules_path

         when /the new mini_module form/
          new_admin_mini_module_path
        else
          nil
        end
      end
    end
  end
end
